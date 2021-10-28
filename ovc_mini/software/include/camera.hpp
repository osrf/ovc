#ifndef CAMERA_INC
#define CAMERA_INC
#include <memory>
#include <string>

#include "i2c_driver.h"

typedef struct camera_dynamic_configs_t
{
  bool frame_rate : 1;
  bool exposure : 1;
} camera_dynamic_configs_t;

typedef struct camera_params_t
{
  int res_x = -1;
  int res_y = -1;
  int fps = -1;
  int bit_depth = -1;
  char data_type[8];
  camera_dynamic_configs_t dynamic_configs = {0};
} camera_params_t;

// TODO move to separate shared header if we want to serialize manually
class I2CCamera
{
protected:
  I2CDriver i2c;
  camera_params_t camera_params;
  bool main_camera;

public:
  I2CCamera(I2CDriver& i2c_dev, bool main_cam)
      : i2c(std::move(i2c_dev)), main_camera(main_cam)
  {
  }

  // TODO add an initialise function with custom sensor mode
  virtual bool initialise(std::string config_name = "__default__") = 0;

  virtual void enableStreaming() = 0;

  virtual void reset() = 0;

  camera_params_t getCameraParams() const { return camera_params; }

  // Triggering main / secondary device settings
  virtual void setMain(){};
  virtual void setSecondary(){};

  // Camera dynamic parameter functions.
  virtual void updateExposure(float ms){};
};

#endif
