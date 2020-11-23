#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>
#include <fstream>
#include <iostream>
#include <cmath>

#include <ovc5_driver/vdma_driver.h>

int VDMADriver::framebuffer_id = 0;

VDMADriver::VDMADriver(int uio_num) : uio(UIODriver(uio_num, UIO_SIZE))
{
  // Start by resetting the DMA
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | (1 << 2));
  while(uio.readRegister(VDMACR) & (1 << 2));
  std::cout << "VDMA Reset" << std::endl;
  memory_file = open("/dev/mem", O_RDWR);
  for (int i=0; i<NUM_FRAMEBUFFERS; ++i)
  {

    memory_mmap[i] = (unsigned char*) mmap(NULL, FRAME_OFFSET, PROT_READ | PROT_WRITE, MAP_SHARED, memory_file,
        FRAME_BASEADDR + framebuffer_id * FRAME_OFFSET);

    if (memory_mmap[i] == MAP_FAILED)
      std::cout << "mmap failed" << std::endl;
    // Make sure Linux allocates the page (2 MB size)
    sendFramebuffer(i, FRAME_BASEADDR + framebuffer_id * FRAME_OFFSET);
    ++framebuffer_id;
  }
}

void VDMADriver::sendFramebuffer(int fb_num, uint32_t address)
{
  // We need to add the offset to make sure we don't overwrite the header
  std::cout << "Sending framebuffer " << std::hex << address << std::endl;
  uio.writeRegister(START_ADDR_0 + fb_num, address);
}

void VDMADriver::setHeader(const std::vector<uint8_t>& header, int index)
{
  if (index == -1)
    index = last_fb;
  //memcpy((void *)(memory_mmap[index] + misalignment_offset), &header[0], header.size());
}

void VDMADriver::configureVDMA(int res_x, int res_y, int bit_depth)
{
  // Start by resetting and waiting a bit
  int bytes_per_pixel = std::ceil(bit_depth / 8.0);
  std::cout << std::dec << "Configuring vdma with res_x = " << res_x << " res_y = " << res_y << " byte depth " << bytes_per_pixel << std::endl;
  // Run DMA
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | 1);
  // Enable frame interrupt
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | (1 << 12));
  // Write stride
  uio.writeRegister(FRMDLY_STRIDE_REG, uio.readRegister(FRMDLY_STRIDE_REG) | res_x * bytes_per_pixel);
  // Horizontal size
  uio.writeRegister(HSIZE_REG, res_x * bytes_per_pixel);
  // Set the mask we will use to reset the ISR
  uio.setResetRegisterMask(VDMASR, uio.readRegister(VDMASR) | (1 << 12));
  startVDMA(res_y);
}

void VDMADriver::startVDMA(int res_y)
{
  uio.writeRegister(VSIZE_REG, res_y);
}

void VDMADriver::updateLastFramebuffer()
{
  // TODO check if we can avoid having last_fb global
  last_fb = (uio.readRegister(PARK_PTR_REG) >> 24) & 0b11111;
  last_fb -= 1;
  if (last_fb < 0) last_fb = NUM_FRAMEBUFFERS - 1;
}

// Return pointer to memory area with image
unsigned char* VDMADriver::getImage()
{
  // Wait until a new frame is generated
  uio.waitInterrupt();
  updateLastFramebuffer();

  return memory_mmap[last_fb];
}
