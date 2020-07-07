#ifndef CAMERA_INC
#define CAMERA_INC
#include <string>
#include <memory>

#include <ovc4_driver/usb_packetdef.h>
#include <ovc4_driver/uio_driver.hpp>

enum class camera_init_ret_t
{
  DONE,
  IN_PROGRESS,
  CONFIG_NOT_FOUND
};

class Camera
{
protected:
  std::unique_ptr<UIODriver> uio;
public:
  virtual camera_init_ret_t initialise(const std::string& config_name, usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual void enableStreaming(usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual void reset(usb_txrx_i2c_t& i2c_pkt) = 0;

  // Get exposure from UIO and send it to I2C
  // TODO return the exposure, and create a SensorManager to manage the cameras
  virtual void updateExposure(usb_txrx_i2c_t& i2c_pkt) = 0;

  void setUioFile(int num)
  {
    uio = std::make_unique<UIODriver>(num);
  }

};


// Append all the camera headers here
#include <ovc4_driver/cameras/picam_v2.hpp>


#endif
