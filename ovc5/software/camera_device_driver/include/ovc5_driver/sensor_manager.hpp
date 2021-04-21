#include <memory>
#include <map>

#include <ovc5_driver/camera.hpp>
#include <ovc5_driver/ethernet_driver.hpp>
#include <ovc5_driver/timer_driver.hpp>

#define NUM_CAMERAS 2

class SensorManager
{
private:
  static constexpr int LINE_BUFFER_SIZE = 400; // Number of lines to wait before tranferring frame
  EthernetClient client;
  Timer line_counter;

  void initCamera(int cam_id, int sensor_mode, int width, int height, int fps);

  std::map<int, std::unique_ptr<I2CCamera>> cameras;

  
public:
  SensorManager(const std::array<int, NUM_CAMERAS>& i2c_devs,
      const std::array<int, NUM_CAMERAS>& vdma_devs, int line_counter_dev);

  void initCameras();

  void streamCameras();

  std::map<int, unsigned char*> getFrames();

  void sendFrames();

  int getNumCameras() const;

  ~SensorManager();

};
