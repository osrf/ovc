#ifndef I2C_DRIVER_H
#define I2C_DRIVER_H 1

#include "fsl_i2c.h"

#include "ovc_hw_defs.h"
#include "usb_packetdef.h"

typedef struct CameraI2C
{
  i2c_master_handle_t master_handle_;
  I2C_Type *base_;

  i2c_master_transfer_t xfer_;

  uint8_t last_read_len_;
  uint8_t register_size_;

  uint8_t tx_buf_[CAM_I2C_BUF_SIZE];
  uint8_t rx_buf_[CAM_I2C_BUF_SIZE];

} CameraI2C;

void camerai2c_init(I2C_Type *base, CameraI2C* cam_i2c);

void camerai2c_configure_slave(CameraI2C* cam_i2c, uint8_t slave_addr, uint8_t reg_addr_size);

// High level function, series of blocking reads / writes
// For this function the CameraI2C* parameter is actually an array of camera_i2c structures
void camerai2c_regops_sequential(CameraI2C* cam_i2cs, usb_rx_packet_t* rx_packet, usb_tx_packet_t* tx_packet);

// High level function for non blocking operations. Only supports writes for now
void camerai2c_regops_sync(CameraI2C* cam_i2cs, usb_rx_packet_t* rx_packet);

// Setup non blocking (interrupt based) transaction
bool camerai2c_read_nonblocking(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len);

bool camerai2c_write_nonblocking(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len);

// Fetch data from non blocking call
void camerai2c_get_read_data(CameraI2C* cam_i2c, uint8_t* buf);

// Wait for all non blocking calls to be finished
void camerai2c_wait_for_complete();

// Blocking calls
bool camerai2c_read(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len);

bool camerai2c_write(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len);

// Private functions
bool camerai2c_transfer_nonblocking_(CameraI2C* cam_i2c);

bool camerai2c_transfer_blocking_(CameraI2C* cam_i2c);

void camerai2c_setup_read_(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len);

void camerai2c_setup_write_(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len);







#endif
