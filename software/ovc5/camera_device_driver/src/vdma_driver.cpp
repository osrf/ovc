#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>
#include <fstream>
#include <iostream>

#include <ovc5_driver/vdma_driver.h>

VDMADriver::VDMADriver(int uio_num) : uio(UIODriver(uio_num, UIO_SIZE))
{
  // We want an aligned word for the DMA, however the header is not word aligned.
  // TODO will still be offset by 1 word if header is actually the correct size, fix.
  configureVDMA();
  memory_file = open("/dev/mem", O_RDWR);
  for (int i=0; i<NUM_FRAMEBUFFERS; ++i)
  {

    memory_mmap[i] = (unsigned char*) mmap(NULL, FRAME_OFFSET, PROT_READ | PROT_WRITE, MAP_SHARED, memory_file,
        FRAME_BASEADDR + i * FRAME_OFFSET);

    if (memory_mmap[i] == MAP_FAILED)
      std::cout << "mmap failed" << std::endl;
    // Make sure Linux allocates the page (2 MB size)
    sendFramebuffer(i, FRAME_BASEADDR + i * FRAME_OFFSET);
  }
  startVDMA();
}

void VDMADriver::sendFramebuffer(int fb_num, uint32_t address)
{
  // We need to add the offset to make sure we don't overwrite the header
  uio.writeRegister(START_ADDR_0 + fb_num, address);
}

void VDMADriver::setHeader(const std::vector<uint8_t>& header, int index)
{
  if (index == -1)
    index = last_fb;
  //memcpy((void *)(memory_mmap[index] + misalignment_offset), &header[0], header.size());
}

void VDMADriver::configureVDMA()
{
  // Start by resetting and waiting a bit
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | (1 << 2));
  while(uio.readRegister(VDMACR) & (1 << 2));
  std::cout << "VDMA Reset" << std::endl;
  // Run DMA
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | 1);
  // Enable frame interrupt
  uio.writeRegister(VDMACR, uio.readRegister(VDMACR) | (1 << 12));
  // Write stride
  uio.writeRegister(FRMDLY_STRIDE_REG, uio.readRegister(FRMDLY_STRIDE_REG) | RES_X);
  // Horizontal size
  uio.writeRegister(HSIZE_REG, RES_X);
  // Set the mask we will use to reset the ISR
  uio.setResetRegisterMask(VDMASR, uio.readRegister(VDMASR) | (1 << 12));
}

void VDMADriver::startVDMA()
{
  uio.writeRegister(VSIZE_REG, RES_Y);
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
