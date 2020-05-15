#include "camera_i2c.h"

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
  cam_i2c->xfer_.slaveAddress = slave_addr;
  cam_i2c->xfer_.subaddressSize = reg_addr_size;

  cam_i2c->xfer_.flags = kI2C_TransferDefaultFlag;
}

// NOTE if transaction fails (i.e. nack) the module might hang, TODO fix
bool camerai2c_transfer_nonblocking_(CameraI2C* cam_i2c)
{
  status_t ret_val = I2C_MasterTransferNonBlocking(cam_i2c->base_, &cam_i2c->master_handle_, &cam_i2c->xfer_);
  if (ret_val == kStatus_Success)
  {
    ++pending_i2c_transactions;
    return true;
  }
  return false;
}

bool camerai2c_transfer_blocking_(CameraI2C* cam_i2c)
{
  // TODO ret_val has more explanatory return values than fail / success (i.e. timeout / NAK)
  return I2C_MasterTransferBlocking(cam_i2c->base_, &cam_i2c->xfer_);
}

// TODO refactor setup read / write functions into generic setup_operation
void camerai2c_setup_read_(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len)
{
  cam_i2c->xfer_.direction = kI2C_Read;
  cam_i2c->xfer_.subaddress = reg_addr;
  cam_i2c->xfer_.data = cam_i2c->rx_buf_;
  cam_i2c->xfer_.dataSize = read_len;
}

bool camerai2c_read_nonblocking(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len)
{
  camerai2c_setup_read_(cam_i2c, reg_addr, read_len);
  if (camerai2c_transfer_nonblocking_(cam_i2c))
  {
    cam_i2c->last_read_len_ = read_len;
    return true;
  }
  cam_i2c->last_read_len_ = 0;
  return false;
}
  
void camerai2c_setup_write_(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len)
{
  memcpy(cam_i2c->tx_buf_, (uint8_t *)&write_val, write_len);
  cam_i2c->xfer_.direction = kI2C_Write;
  cam_i2c->xfer_.subaddress = reg_addr;
  cam_i2c->xfer_.data = cam_i2c->tx_buf_;
  cam_i2c->xfer_.dataSize = write_len;
}

bool camerai2c_write_nonblocking(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len)
{
  camerai2c_setup_write_(cam_i2c, reg_addr, write_val, write_len);
  return camerai2c_transfer_nonblocking_(cam_i2c);
}

bool camerai2c_read(CameraI2C* cam_i2c, uint32_t reg_addr, uint8_t read_len)
{
  camerai2c_setup_read_(cam_i2c, reg_addr, read_len);
  if (camerai2c_transfer_blocking_(cam_i2c))
  {
    cam_i2c->last_read_len_ = read_len;
    return true;
  }
  cam_i2c->last_read_len_ = 0;
  return false;
}

bool camerai2c_write(CameraI2C* cam_i2c, uint32_t reg_addr, uint32_t write_val, uint8_t write_len)
{
  camerai2c_setup_write_(cam_i2c, reg_addr, write_val, write_len);
  return camerai2c_transfer_blocking_(cam_i2c);
}

void camerai2c_get_read_data(CameraI2C* cam_i2c, uint8_t* buf)
{
  memcpy(buf, cam_i2c->rx_buf_, cam_i2c->last_read_len_);
  // Reset the read buffer
  cam_i2c->last_read_len_ = 0;
}

void camerai2c_wait_for_complete()
{
  // TODO timeout?
  while(pending_i2c_transactions);
}
