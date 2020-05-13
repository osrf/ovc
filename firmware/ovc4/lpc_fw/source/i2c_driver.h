#ifndef I2C_DRIVER_H
#define I2C_DRIVER_H 1

#include "ovc_hw_defs.h"
#include "fsl_i2c.h"

typedef struct CameraI2C
{
  i2c_master_handle_t master_handle_;
  I2C_Type *base_;

  uint8_t slave_addr_; 
  uint8_t reg_addr_size_; // Size in bytes of the register address

  uint8_t last_read_len_;

  uint8_t tx_buf_[CAM_I2C_BUF_SIZE];
  uint8_t rx_buf_[CAM_I2C_BUF_SIZE];

} CameraI2C;

void camerai2c_init(I2C_Type *base, CameraI2C* cam_i2c);

void camerai2c_configure_slave(CameraI2C* cam_i2c, uint8_t slave_addr, uint8_t reg_addr_size);

bool camerai2c_setup_read(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len);

bool camerai2c_setup_write(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len);

void camerai2c_get_read_data(CameraI2C* cam_i2c, uint8_t* buf);

void camerai2c_wait_for_complete();










#endif
