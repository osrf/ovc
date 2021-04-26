#include <fcntl.h>
#include <sys/ioctl.h>

#include <iostream>
#include <string>
#include <vector>
extern "C"
{
#include <i2c/smbus.h>
#include <linux/i2c-dev.h>
#include <linux/i2c.h>
}

#include "ovc5_driver/i2c_driver.h"

#include <cassert>

I2CDriver::I2CDriver(int i2c_dev)
{
  std::string i2c_filename("/dev/i2c-" + std::to_string(i2c_dev));
  i2c_fd = open(i2c_filename.c_str(), O_RDWR);
  if (i2c_fd == -1)
    std::cout << "Couldn't open I2C file " << i2c_filename << std::endl;

  std::cout << "I2C Initialization done" << std::endl;
}

void I2CDriver::assignDevice(int i2c_addr, int register_size)
{
  reg_size = register_size;
  // Set the slave address for the device
  if (ioctl(i2c_fd, I2C_SLAVE, i2c_addr) < 0)
    std::cout << "Couldn't set slave address" << std::endl;
}

bool I2CDriver::initialized() const { return reg_size > 0; }

int32_t I2CDriver::readRegister(uint16_t reg_addr)
{
  assert(initialized());
  i2c_smbus_write_byte_data(i2c_fd, reg_addr >> 8, reg_addr & 0xFF);
  int32_t ret_val = 0;
  // Data is returned MSB first
  for (int i = reg_size - 1; i >= 0; --i)
    ret_val |= i2c_smbus_read_byte(i2c_fd) << (i * 8);
  return ret_val;
}

int I2CDriver::writeRegister(const regop_t& regop)
{
  assert(initialized());
  // We need to add one byte for address
  std::vector<uint8_t> payload(reg_size + 1);
  payload[0] = regop.addr & 0xFF;
  for (size_t i = 1; i <= reg_size; ++i)
    payload[i] = regop.i32 >> (8 * (reg_size - i));
  return i2c_smbus_write_i2c_block_data(i2c_fd, regop.addr >> 8, payload.size(),
                                        &payload[0]);
}
