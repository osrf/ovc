#include <memory>
#include <map>

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

  std::map<int, std::unique_ptr<Camera>> cameras;

  void initCamera(int cam_id, int sensor_mode, int width, int height, int fps);
  
public:
  static std::unique_ptr<SensorManager> make();

  ~SensorManager();

  void probeImagers();

  bool initCameras();

  void updateExposure() const;

  std::vector<int> getProbedCameraIds() const;

  std::shared_ptr<OVCImage> getFrame(int cam_id) const;
};
