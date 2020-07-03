#ifndef CAMERA_INC
#define CAMERA_INC
#include <ovc4_driver/usb_packetdef.h>

enum class camera_init_ret_t
{
  DONE,
  IN_PROGRESS,
  CONFIG_NOT_FOUND
};

class Camera
{
public:
  virtual camera_init_ret_t initialise(const std::string& config_name, usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual void enable_streaming(usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual void reset(usb_txrx_i2c_t& i2c_pkt) = 0;


};


// Append all the camera headers here
#include <ovc4_driver/cameras/picam_v2.hpp>


#endif
