#include <map>
#include <memory>

#include "ovc5_driver/camera.hpp"
#include "ovc5_driver/ethernet_driver.hpp"
#include "ovc5_driver/gpio_driver.hpp"
#include "ovc5_driver/timer_driver.hpp"

// Number of regular gpio before EMIO.
#define GPIO_EMIO_OFFSET 78
// Chip number that manages PL GPIO. Find at /sys/class/gpio/
#define GPIO_CHIP_NUMBER 338
// EMIO for Blue LED.
#define GPIO_LED_PIN GPIO_EMIO_OFFSET + 7
// Pin to trigger sensor sampling.
#define GPIO_TRIG_PIN GPIO_EMIO_OFFSET + 15
// GPIO offset to select for line counter (16-21).
#define GPIO_SELECT_OFFSET GPIO_EMIO_OFFSET + 16

struct camera_config_t
{
  int id;
  int i2c_dev;
  int vdma_dev;
};

class SensorManager
{
private:
  // Number of lines to wait before tranferring frame
  static constexpr int LINE_BUFFER_SIZE = 400;

  EthernetClient client;

  Timer line_counter;

  std::unique_ptr<GPIOChip> gpio;

  void initCamera(int cam_id, int sensor_mode, int width, int height, int fps);

  std::map<int, std::unique_ptr<I2CCamera>> cameras;

  int primary_cam_;

public:
  SensorManager(const std::vector<camera_config_t>& cams, int line_counter_dev,
                int primary_cam);

  void initCameras();

  void streamCameras();

  std::map<int, unsigned char*> getFrames();

  void sendFrames();

  void recvCommand();

  int getNumCameras() const;

  ~SensorManager();
};
