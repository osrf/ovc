#include "ovc5_driver/uio_driver.hpp"

#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

#include <iostream>
#include <string>

UIODriver::UIODriver(int uio_num, size_t map_size)
{
  std::string uio_filename("/dev/uio" + std::to_string(uio_num));
  uio_file = open(uio_filename.c_str(), O_RDWR);
  uio_mmap = (unsigned int *)mmap(
      NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, uio_file, 0);
  if (uio_file < 0)
    std::cout << "Failed in opening uio file " << uio_num << std::endl;
}

void UIODriver::writeRegister(int reg_addr, int value)
{
  *(uio_mmap + reg_addr) = value;
}

unsigned int UIODriver::readRegister(int reg_addr) const
{
  return *(uio_mmap + reg_addr);
}

// Used to reset the interrupt, depends on UIO device
void UIODriver::setResetRegisterMask(unsigned int reg_addr, unsigned int mask)
{
  reset_register = reg_addr;
  reset_mask = mask;
}

bool UIODriver::waitInterrupt()
{
  unsigned int dummy;
  fd_set set;
  struct timeval timeout;
  int rv;

  timeout.tv_sec = 1;
  timeout.tv_usec = 0;

  FD_ZERO(&set);
  FD_SET(uio_file, &set);

  // Start by resetting status register (only the masked bits)
  writeRegister(reset_register, readRegister(reset_register) & (~reset_mask));
  // Reset UIO and blocking read
  size_t io_size;
  io_size = write(uio_file, (char *)&IRQ_RST, sizeof(IRQ_RST));
  if (io_size != sizeof(IRQ_RST))
  {
    std::cout << "Failed to write irq_rst" << std::endl;
    return false;
  }
  rv = select(uio_file + 1, &set, NULL, NULL, &timeout);
  if (0 < rv)
  {
    io_size = read(uio_file, &dummy, sizeof(dummy));
    if (io_size != sizeof(dummy))
    {
      std::cout << "Failed to read dummy value" << std::endl;
    }
  }
  else
  {
    std::cout << "Timed out or Error." << std::endl;
    return false;
  }
  return true;
}
