// Driver to use the sysfs interface for GPIO.
#ifndef GPIO_DRIVER_HPP
#define GPIO_DRIVER_HPP
#include <unordered_map>

#define DEFAULT_CHIP_ID 334 // WAS 338 in Vivado 2020.2
#define GPIO_SYSFS_PATH "/sys/class/gpio"
#define GPIO_OUTPUT 0
#define GPIO_INPUT 1

#define GPIO_NAME_SIZE 4

struct gpio_pin_config_t
{
  int valuefd;
  int direction;
};

class GPIOChip
{
public:
  GPIOChip(int chip_num);
  ~GPIOChip();

  bool openPin(int pin_num, int direction);
  void closePin(int pin_num);

  void setValue(int pin_num, bool value);
  bool getValue(int pin_num);

private:
  int chip_num_;
  int num_managed_pins_;
  char num_buffer_[GPIO_NAME_SIZE];
  std::unordered_map<int, gpio_pin_config_t> pin_map_;

  bool pinRegistered(int pin_num);
};
#endif
