#ifndef UIO_DRIVER_INCLUDE_H
#define UIO_DRIVER_INCLUDE_H

class UIODriver
{
  const int IRQ_RST = 1;
  int uio_file;
  unsigned int *uio_mmap;

  unsigned int reset_register, reset_mask;

public:
  UIODriver(int uio_num, size_t map_size);

  void setResetRegisterMask(unsigned int reg_addr, unsigned int mask);

  unsigned int readRegister(int reg_addr) const;
  void writeRegister(int reg_addr, int value);

  void waitInterrupt();
};
#endif
