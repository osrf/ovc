#include <map>
#include <memory>

#include "ovc5_driver/camera.hpp"
#include "ovc5_driver/ethernet_driver.hpp"
#include "ovc5_driver/gpio_driver.hpp"
#include "ovc5_driver/timer_driver.hpp"

#define NUM_CAMERAS 2

// Number of regular gpio before EMIO.
#define GPIO_EMIO_OFFSET 78
// Chip number that manages PL GPIO. Find at /sys/class/gpio/
#define GPIO_CHIP_NUMBER 338
// EMIO for Blue LED.
#define GPIO_LED_PIN GPIO_EMIO_OFFSET + 7
// Pin to trigger sensor sampling.
#define GPIO_TRIG_PIN GPIO_EMIO_OFFSET + 15

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

public:
  SensorManager(const std::array<int, NUM_CAMERAS>& cam_nums,
                const std::array<int, NUM_CAMERAS>& i2c_devs,
                const std::array<int, NUM_CAMERAS>& vdma_devs,
                int line_counter_dev);

  void initCameras();

  void streamCameras();

  std::map<int, unsigned char*> getFrames();

  void sendFrames();

  void recvCommand();

  int getNumCameras() const;

  ~SensorManager();
};
