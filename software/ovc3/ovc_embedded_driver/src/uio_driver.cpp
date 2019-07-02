#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <string>
#include <iostream>

#include <ovc_embedded_driver/uio_driver.h>

UIODriver::UIODriver(int uio_num, size_t map_size)
{
  std::string uio_filename("/dev/uio" + std::to_string(uio_num));
  uio_file = open(uio_filename.c_str(), O_RDWR);
  uio_mmap = (unsigned int*) mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, uio_file, 0);
  if (uio_file < 0)
    std::cout << "Failed in opening uio file " << uio_num << std::endl;
}


void UIODriver::writeRegister(int reg_addr, int value)
{
  *(uio_mmap + reg_addr) = value;
};

unsigned int UIODriver::readRegister(int reg_addr) const
{
  return *(uio_mmap + reg_addr); 
};

// Used to reset the interrupt, depends on UIO device
void UIODriver::setResetRegisterMask(unsigned int reg_addr, unsigned int mask)
{
  reset_register = reg_addr;
  reset_mask = mask;
}

void UIODriver::waitInterrupt()
{
  unsigned int dummy;
  // Start by resetting status register
  writeRegister(reset_register, reset_mask);
  // Reset UIO and blocking read
  write(uio_file, (char *)&IRQ_RST, sizeof(IRQ_RST));
  unsigned int nb = read(uio_file, &dummy, sizeof(dummy));
}
