#ifndef CAMERA_INC
#define CAMERA_INC
#include <string>
#include <memory>

#include <opencv2/opencv.hpp>

#include <Argus/Argus.h>
#include <EGLStream/EGLStream.h>

#include <ovc4_driver/usb_packetdef.h>
#include <ovc4_driver/uio_driver.hpp>

#define PROPRIETARY_SENSORS 1

enum class camera_init_ret_t
{
  DONE,
  IN_PROGRESS,
  CONFIG_NOT_FOUND
};

enum class sensor_type_t
{
  PiCameraV2,
  PiCameraHQ,
  AR0521
};

// TODO move to separate shared header if we want to serialize manually
struct OVCImage
{
  std::vector<uint8_t> buf;
  uint32_t height;
  uint32_t width;
  uint64_t timestamp; // In nanoseconds
  uint64_t frame_id;
  uint32_t stride;
};

class Camera
{
private:
  // We need to close it on destruction
  Argus::UniqueObj<Argus::CaptureSession> capture_session;

  Argus::UniqueObj<EGLStream::FrameConsumer> consumer;

  Argus::UniqueObj<Argus::OutputStream> output_stream;

  Argus::UniqueObj<Argus::Request> request;

  std::vector<Argus::SensorMode*> sensor_modes;

  int nvbuffer_fd = -1;

  std::unique_ptr<cv::VideoCapture> video_cap;

  OVCImage ret_img;

protected:
  std::unique_ptr<UIODriver> uio;
public:
  virtual ~Camera();

  virtual sensor_type_t getType() const = 0;

  virtual camera_init_ret_t initialise(const std::string& config_name, usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual void enableStreaming(usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual void reset(usb_txrx_i2c_t& i2c_pkt) = 0;

  // Get exposure from UIO and send it to I2C
  // TODO return the exposure, and create a SensorManager to manage the cameras
  virtual void updateExposure(usb_txrx_i2c_t& i2c_pkt) = 0;

  virtual camera_init_ret_t registerDump(usb_txrx_i2c_t& i2c_pkt) {}

  void setUioFile(int num)
  {
    uio = std::make_unique<UIODriver>(num);
  }

  void initArgus(Argus::UniqueObj<Argus::CaptureSession> capture_session,
      Argus::CameraDevice* camera_device, int sensor_mode);

  void initGstreamer();

  OVCImage getArgusFrame();
  OVCImage getGstreamerFrame();

  // TODO consider getter and setter for sensor_mode
};


// Append all the camera headers here
#include <ovc4_driver/cameras/picam_v2.hpp>
#include <ovc4_driver/cameras/picam_hq.hpp>
#if PROPRIETARY_SENSORS
#include <ovc4_driver/cameras/ar0521.hpp>

#endif

#endif
