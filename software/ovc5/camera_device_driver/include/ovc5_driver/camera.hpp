#ifndef CAMERA_INC
#define CAMERA_INC
#include <string>
#include <memory>

#include <ovc5_driver/i2c_driver.h>

#define PROPRIETARY_SENSORS 0

enum class sensor_type_t
{
  PiCameraV2,
  PiCameraHQ,
  AR0521
};

// TODO move to separate shared header if we want to serialize manually
class I2CCamera
{
protected:
  std::unique_ptr<I2CDriver> i2c;

public:
  I2CCamera(std::unique_ptr<I2CDriver> i2c_dev) :
    i2c(std::move(i2c_dev))
  {}

  //virtual sensor_type_t getType() const = 0;

  virtual bool initialise(const std::string& config_name) = 0;

  virtual void enableStreaming() = 0;

  virtual void reset() = 0;
  /*

  // Get exposure from UIO and send it to I2C
  // TODO return the exposure, and create a SensorManager to manage the cameras
  virtual void updateExposure(usb_txrx_i2c_t& i2c_pkt) = 0;

  void initArgus(Argus::UniqueObj<Argus::CaptureSession> capture_session,
      Argus::CameraDevice* camera_device, int sensor_mode);

  void initGstreamer(int sensor_id, int sensor_mode, int width, int height, int fps);

  // TODO consider getter and setter for sensor_mode
  */
};


// Append all the camera headers here
#include <ovc5_driver/cameras/picam_v2.hpp>
//#include <ovc4_driver/cameras/picam_hq.hpp>
#if PROPRIETARY_SENSORS
#include <ovc5_driver/cameras/ar0521.hpp>

#endif

#endif
