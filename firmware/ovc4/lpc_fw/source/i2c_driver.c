#include "i2c_driver.h"

// TODO change flag to support multiple I2Cs (i.e. counter)
volatile int pending_i2c_transactions = 0;

static void i2c_master_callback(I2C_Type *base, i2c_master_handle_t *handle, status_t status, void *userData)
{
  --pending_i2c_transactions;
}

void camerai2c_init(I2C_Type *base, CameraI2C* cam_i2c)
{
  cam_i2c->base_ = base;
  i2c_master_config_t master_config;

  I2C_MasterGetDefaultConfig(&master_config);
  /*
   * masterConfig.debugEnable = false;
   * masterConfig.ignoreAck = false;
   * masterConfig.pinConfig = kI2C_2PinOpenDrain;
   * masterConfig.baudRate_Bps = 100000U;
   * masterConfig.busIdleTimeout_ns = 0;
   * masterConfig.pinLowTimeout_ns = 0;
   * masterConfig.sdaGlitchFilterWidth_ns = 0;
   * masterConfig.sclGlitchFilterWidth_ns = 0;
   */
  // TODO support custom baud rates
  master_config.baudRate_Bps = DEFAULT_CAM_I2C_FREQUENCY;

  I2C_MasterInit(base, &master_config, I2C_CLOCK_FREQUENCY);

  I2C_MasterTransferCreateHandle(base, &cam_i2c->master_handle_, i2c_master_callback, NULL);
}

void camerai2c_configure_slave(CameraI2C* cam_i2c, uint8_t slave_addr, uint8_t reg_addr_size)
{
  cam_i2c->slave_addr_ = slave_addr;
  cam_i2c->reg_addr_size_ = reg_addr_size;
}

bool camerai2c_setup_read(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len)
{
  i2c_master_transfer_t xfer = {0};
  xfer.slaveAddress = cam_i2c->slave_addr_;
  xfer.direction = kI2C_Read;
  xfer.subaddress = reg_addr;
  xfer.subaddressSize = cam_i2c->reg_addr_size_;
  xfer.data = cam_i2c->rx_buf_;
  xfer.dataSize = read_len;
  xfer.flags = kI2C_TransferDefaultFlag;

  status_t ret_val = I2C_MasterTransferNonBlocking(cam_i2c->base_, &cam_i2c->master_handle_, &xfer);
  if (ret_val == kStatus_Success)
  {
    ++pending_i2c_transactions;
    cam_i2c->last_read_len_ = read_len;
    return true;
  }
  cam_i2c->last_read_len_ = 0;
  return false;
}
  
bool camerai2c_setup_write(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len)
{
  memcpy(cam_i2c->tx_buf_, (uint8_t *)&write_val, write_len);
  i2c_master_transfer_t xfer = {0};
  xfer.slaveAddress = cam_i2c->slave_addr_;
  xfer.direction = kI2C_Write;
  xfer.subaddress = reg_addr;
  xfer.subaddressSize = cam_i2c->reg_addr_size_;
  xfer.data = cam_i2c->tx_buf_;
  xfer.dataSize = write_len;
  xfer.flags = kI2C_TransferDefaultFlag;

  status_t ret_val = I2C_MasterTransferNonBlocking(cam_i2c->base_, &cam_i2c->master_handle_, &xfer);
  if (ret_val == kStatus_Success)
  {
    ++pending_i2c_transactions;
    return true;
  }
  return false;
}

void camerai2c_wait_for_complete()
{
  // TODO timeout?
  while(pending_i2c_transactions);
}
