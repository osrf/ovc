#ifndef CAMERA_INC
#define CAMERA_INC
#include <memory>
#include <string>

#include "ovc5_driver/i2c_driver.h"
#include "ovc5_driver/vdma_driver.h"

typedef struct camera_params_t
{
  int res_x = -1;
  int res_y = -1;
  int fps = -1;
  int bit_depth = -1;
  char data_type[8] = "";
} camera_params_t;

// TODO move to separate shared header if we want to serialize manually
class I2CCamera
{
protected:
  I2CDriver i2c;
  VDMADriver vdma;
  camera_params_t camera_params;
  bool main_camera;

  void initVDMA(const camera_params_t& params)
  {
    camera_params = params;
    vdma.configureVDMA(
        params.res_x, params.res_y, params.bit_depth, main_camera);
  }

public:
  I2CCamera(I2CDriver& i2c_dev, int vdma_dev, int cam_id, bool main_cam)
      : i2c(std::move(i2c_dev)), vdma(vdma_dev, cam_id), main_camera(main_cam)
  {
  }

  // TODO add an initialise function with custom sensor mode
  virtual bool initialise(std::string config_name = "__default__") = 0;

  virtual void enableStreaming() = 0;

  virtual void reset() = 0;

  // A frame offset of -1 will return the frame just written, 0 is the one
  // currently being written
  unsigned char* getFrame(int frame_offset = -1)
  {
    return vdma.getImage(frame_offset);
  }

  unsigned char* getFrameNoInterrupt(int frame_offset = 0)
  {
    return vdma.getImageNoInterrupt(frame_offset);
  }

  void flushCache() { vdma.flushCache(); }

  camera_params_t getCameraParams() const { return camera_params; }

  // Triggering main / secondary device settings
  virtual void setMain(){};
  virtual void setSecondary(){};
};

#endif
