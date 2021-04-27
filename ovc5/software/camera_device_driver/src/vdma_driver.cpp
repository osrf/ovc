#include "ovc5_driver/vdma_driver.h"

#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#include <cmath>
#include <fstream>
#include <iostream>

VDMADriver::VDMADriver(int uio_num, int cam_id)
    : uio(UIODriver(uio_num, UIO_SIZE))
{
  // Start by resetting the DMA
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | (1 << 2));
  while (uio.readRegister(VDMACR) & (1 << 2))
    ;
  std::cout << "VDMA Reset" << std::endl;
  for (int i = 0; i < NUM_FRAMEBUFFERS; ++i)
  {
    std::string camera_name =
        "cam" + std::to_string(cam_id) + "_" + std::to_string(i);
    std::string buffer_filename = "/dev/" + camera_name;
    auto fb_data = readFramebuffer(camera_name);
    std::cout << "Opening file " << buffer_filename << " with size " << std::hex
              << fb_data.second << std::endl;
    int memory_file = open(buffer_filename.c_str(), O_RDWR);
    std::string sync_filename =
        "/sys/class/u-dma-buf/" + camera_name + "/sync_for_cpu";
    sync_fd[i] = open(sync_filename.c_str(), O_WRONLY);
    if (memory_file < 0) std::cout << "fopen failed" << std::endl;
    memory_mmap[i] = (unsigned char*)mmap(
        NULL, fb_data.second, PROT_READ, MAP_SHARED, memory_file, 0);

    if (memory_mmap[i] == MAP_FAILED) std::cout << "mmap failed" << std::endl;
    sendFramebuffer(i, fb_data.first);
  }
}

// Gets the framebuffer addr from the matching /sys file
// returns a {address, size} pair for the mmap
std::pair<size_t, size_t> VDMADriver::readFramebuffer(
    const std::string& buffer_name)
{
  std::pair<size_t, size_t> ret;
  std::string sys_folder = "/sys/class/u-dma-buf/" + buffer_name + "/";
  std::string addr_filename = sys_folder + "phys_addr";
  std::string size_filename = sys_folder + "size";
  std::fstream addr_file;
  std::fstream size_file;
  addr_file.open(addr_filename, std::fstream::in);
  size_file.open(size_filename, std::fstream::in);
  addr_file >> std::hex >> ret.first;
  size_file >> ret.second;
  return ret;
}

void VDMADriver::sendFramebuffer(int fb_num, uint32_t address)
{
  // We need to add the offset to make sure we don't overwrite the header
  std::cout << "Sending framebuffer " << std::hex << address << std::endl;
  uio.writeRegister(START_ADDR_0 + fb_num, address);
}

void VDMADriver::setHeader(const std::vector<uint8_t>& header, int index)
{
  if (index == -1) index = last_fb;
  // memcpy((void *)(memory_mmap[index] + misalignment_offset), &header[0],
  // header.size());
}

void VDMADriver::configureVDMA(int res_x, int res_y, int bit_depth,
                               bool enable_interrupt)
{
  // Start by resetting and waiting a bit
  double bytes_per_pixel = bit_depth / 8.0;
  std::cout << std::dec << "Configuring vdma with res_x = " << res_x
            << " res_y = " << res_y << " byte depth " << bytes_per_pixel
            << " interrupt enable is " << (int)enable_interrupt << std::endl;
  // Run DMA
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | 1);
  // Enable frame interrupt
  if (enable_interrupt)
    uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | (1 << 12));
  // Write stride
  uio.writeRegister(FRMDLY_STRIDE_REG,
                    uio.readRegister(FRMDLY_STRIDE_REG) |
                        (int)std::round(res_x * bytes_per_pixel));
  // Horizontal size
  uio.writeRegister(HSIZE_REG, std::round(res_x * bytes_per_pixel));
  // Set the mask we will use to reset the ISR
  uio.setResetRegisterMask(VDMASR, uio.readRegister(VDMASR) | (1 << 12));
  startVDMA(res_y);
}

void VDMADriver::startVDMA(int res_y) { uio.writeRegister(VSIZE_REG, res_y); }

void VDMADriver::updateLastFramebuffer(int frame_offset)
{
  // TODO check if we can avoid having last_fb global
  last_fb = (uio.readRegister(PARK_PTR_REG) >> 24) & 0b11111;
  last_fb -= frame_offset;
  if (last_fb < 0) last_fb = NUM_FRAMEBUFFERS - 1;
}

// Return pointer to memory area with image
unsigned char* VDMADriver::getImage(int frame_offset)
{
  // Wait until a new frame is generated
  uio.waitInterrupt();
  updateLastFramebuffer(frame_offset);
  flushCache();

  std::cout << "last master fb is " << last_fb << std::endl;
  return memory_mmap[last_fb];
}

unsigned char* VDMADriver::getImageNoInterrupt(int frame_offset)
{
  // Fetch an image without waiting for UIO interrupt
  // uio.waitInterrupt();
  updateLastFramebuffer(frame_offset);
  std::cout << "last fb is " << last_fb << std::endl;

  return memory_mmap[last_fb];
}

void VDMADriver::flushCache()
{
  // Flush the cache
  size_t io_size = write(sync_fd[last_fb], "1", 1);
  if (io_size != 1)
  {
    std::cout << "Failed to flush cache" << std::endl;
  }
}
