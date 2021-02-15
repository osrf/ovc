#ifndef CAMERA_INC
#define CAMERA_INC
#include <string>
#include <memory>

#include <ovc5_driver/i2c_driver.h>
#include <ovc5_driver/vdma_driver.h>

enum class sensor_type_t
{
  PiCameraV2,
  PiCameraHQ,
  AR0521
};

typedef struct camera_params_t
{
  int res_x = -1;
  int res_y = -1;
  int fps = -1;
  int bit_depth = -1;
} camera_params_t;

// TODO move to separate shared header if we want to serialize manually
class I2CCamera
{
protected:
  I2CDriver i2c;
  VDMADriver vdma;
  camera_params_t camera_params;

  void initVDMA(const camera_params_t& params)
  {
    camera_params = params;
    vdma.configureVDMA(params.res_x, params.res_y, params.bit_depth);
  }

public:
  I2CCamera(I2CDriver& i2c_dev, int vdma_dev, int cam_id) :
    i2c(std::move(i2c_dev)), vdma(vdma_dev, cam_id)
  {}

  //virtual sensor_type_t getType() const = 0;

  // TODO add an initialise function with custom sensor mode
  virtual bool initialise(std::string config_name = "__default__") = 0;

  virtual void enableStreaming() = 0;

  virtual void reset() = 0;

  unsigned char* getFrame()
  {
    return vdma.getImage();
  }

  camera_params_t getCameraParams() const
  {
    return camera_params;
  }
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



#endif
