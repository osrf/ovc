// Driver to use the sysfs interface for GPIO.
#include <unordered_map>

#define DEFAULT_CHIP_ID 338
#define GPIO_SYSFS_PATH "/sys/class/gpio"
#define GPIO_OUTPUT 0
#define GPIO_INPUT 1

#define GPIO_NAME_SIZE 4

struct gpio_pin_config_t
{
  int valuefd;
  int direction;
}

class GPIOChip
{
public:
  GPIOChip(int chip_num) : chip_num_(chip_num) {}

  bool openPin(int pin_num, int direction);
  void closePin(int pin_num);

  void setValue(int pin_num, bool value);
  bool getValue(int pin_num);

private:
  int chip_num_;
  char num_buffer_[GPIO_NAME_SIZE];
  std::unordered_map<int, gpio_pin_config_t> pin_map_;

  bool pinRegistered(int pin_num);
};
