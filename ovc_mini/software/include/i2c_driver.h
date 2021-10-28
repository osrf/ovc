#ifndef I2C_DRIVER_H
#define I2C_DRIVER_H
#include <string>

typedef struct regop_t
{
  // Assume all writes
  int16_t addr;
  union
  {
    float f32;
    int32_t i32;
    uint32_t u32;
    uint16_t u16;
    uint8_t u8;
  };
} regop_t;

inline regop_t writeRegOp(int16_t addr, int32_t data)
{
  regop_t regop;
  regop.addr = addr;
  // Assume 32 bits, will zero pad if the data is smaller
  regop.i32 = data;
  return regop;
}

class I2CDriver
{
  int i2c_fd;
  int reg_size = -1;

  bool initialized() const;

public:
  int32_t readRegister(uint16_t reg_addr);
  int burstRead(uint16_t reg_addr, size_t len, uint16_t* data);
  int writeRegister(const regop_t& regop);

  I2CDriver(int i2c_dev);

  void assignDevice(int i2c_addr, int register_size);
};
#endif
