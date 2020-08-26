#include <memory>

#include <Argus/Argus.h>

#include <ovc4_driver/usb_driver.hpp>
#include <ovc4_driver/camera.hpp>

class SensorManager
{
private:
  std::unique_ptr<USBDriver> usb;

  // TODO UIO probing
  // Argus objects
  Argus::UniqueObj<Argus::CameraProvider> camera_provider;
  std::vector<Argus::CameraDevice*> camera_devices;

  std::array<std::unique_ptr<Camera>, NUM_CAMERAS> cameras;

  void initCamera(int cam_id, const std::string& config_name);
  
public:
  static std::unique_ptr<SensorManager> make();

  ~SensorManager();

  void probeImagers();

  bool initCameras();

  void updateExposure();

  OVCImage getFrames();
};
