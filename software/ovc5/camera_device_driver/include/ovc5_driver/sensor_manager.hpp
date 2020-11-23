#include <memory>
#include <map>

#include <ovc5_driver/camera.hpp>
#include <ovc5_driver/ethernet_driver.hpp>

#define NUM_CAMERAS 2

class SensorManager
{
private:
  EthernetPublisher pub;

  void initCamera(int cam_id, int sensor_mode, int width, int height, int fps);

  std::map<int, std::unique_ptr<I2CCamera>> cameras;

  
public:
  SensorManager(const std::array<int, NUM_CAMERAS>& i2c_devs,
      const std::array<int, NUM_CAMERAS>& vdma_devs);

  void initCameras();

  std::map<int, unsigned char*> getFrames();

  void publishFrames();

  /*
  ~SensorManager();

  void probeImagers();


  void updateExposure(int main_camera_id) const;

  std::vector<int> getProbedCameraIds() const;

  std::shared_ptr<OVCImage> getFrame(int cam_id) const;
  */
};
