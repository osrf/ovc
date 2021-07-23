#include "ovc5_driver/gpio_driver.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <cstring>
#include <iostream>
#include <string>
#include <vector>

GPIOChip::GPIOChip(int chip_num) : chip_num_(chip_num)
{
  sprintf(num_buffer_, "%d", chip_num_);
  int ngpiofd =
      open((std::string(GPIO_SYSFS_PATH) + "/gpiochip" + num_buffer_).c_str(),
           O_RDONLY);

  if (ngpiofd < 0)
  {
    std::cout << "Cannot open GPIO chip ngpio fd" << std::endl;
    return;
  }

  size_t num_chars = read(ngpiofd, num_buffer_, GPIO_NAME_SIZE);
  close(ngpiofd);
  if (0 >= num_chars)
  {
    std::cout << "Failed to read number of pins for chip " << chip_num
              << std::endl;
    return;
  }
  num_managed_pins_ = std::atoi(num_buffer_);
}

GPIOChip::~GPIOChip()
{
  std::vector<int> pins;
  for (const auto &key_value : pin_map_)
  {
    // Turn off any outputs.
    if (GPIO_OUTPUT == key_value.second.direction)
    {
      setValue(key_value.first, false);
    }
    pins.push_back(key_value.first);
  }
  // Must store numbers separately as they are removed when the pin closes.
  for (int pin : pins)
  {
    closePin(pin);
  }
}

bool GPIOChip::pinRegistered(int pin_num)
{
  return !(pin_map_.find(pin_num) == pin_map_.end());
}

bool GPIOChip::openPin(int pin_num, int direction)
{
  std::cout << "Opening pin " << chip_num_ + pin_num << std::endl;
  if (pinRegistered(pin_num))
  {
    return true;
  }

  if (pin_num > num_managed_pins_ || pin_num < 0)
  {
    std::cout << "Cannot export GPIO, pin number out of range" << std::endl;
  }

  int exportfd, directionfd;
  size_t num_chars;
  gpio_pin_config_t config;

  // The GPIO has to be exported to be able to see it in sysfs.
  exportfd = open((std::string(GPIO_SYSFS_PATH) + "/export").c_str(), O_WRONLY);
  if (exportfd < 0)
  {
    std::cout << "Cannot open GPIO export fd" << std::endl;
    return false;
  }

  // Offset the chip num by the pin number and convert it to a string.
  sprintf(num_buffer_, "%d", chip_num_ + pin_num);
  num_chars = write(exportfd, num_buffer_, GPIO_NAME_SIZE);
  close(exportfd);
  if (0 >= num_chars)
  {
    std::cout << "Failed to export pin " << pin_num << std::endl;
    return false;
  }

  std::string pin_path = std::string(GPIO_SYSFS_PATH) + "/gpio" + num_buffer_;
  directionfd = open((pin_path + "/direction").c_str(), O_RDWR);
  if (directionfd < 0)
  {
    std::cout << "Cannot open GPIO direction fd" << std::endl;
    return false;
  }

  config.direction = direction;
  if (config.direction == GPIO_OUTPUT)
  {
    num_chars = write(directionfd, "out", 4);
  }
  else
  {
    num_chars = write(directionfd, "in", 3);
  }
  close(directionfd);
  if (0 >= num_chars)
  {
    std::cout << "Failed to set direction of pin " << pin_num << std::endl;
    return false;
  }

  config.valuefd = open((pin_path + "/value").c_str(), O_RDWR);
  if (config.valuefd < 0)
  {
    std::cout << "Cannot open GPIO value" << std::endl;
    return false;
  }
  pin_map_[pin_num] = config;
  return true;
}

void GPIOChip::closePin(int pin_num)
{
  std::cout << "Closing pin " << chip_num_ + pin_num << std::endl;
  if (!pinRegistered(pin_num))
  {
    return;
  }

  // The GPIO has to be exported to be able to see it in sysfs.
  int unexportfd =
      open((std::string(GPIO_SYSFS_PATH) + "/unexport").c_str(), O_WRONLY);
  if (unexportfd < 0)
  {
    std::cout << "Cannot open GPIO unexport fd" << std::endl;
  }

  // Offset the chip num by the pin number and convert it to a string.
  sprintf(num_buffer_, "%d", chip_num_ + pin_num);
  size_t num_chars = write(unexportfd, num_buffer_, GPIO_NAME_SIZE);
  close(unexportfd);
  if (0 >= num_chars)
  {
    std::cout << "Failed to unexport pin " << pin_num << std::endl;
  }

  close(pin_map_[pin_num].valuefd);
  pin_map_.erase(pin_num);
}

void GPIOChip::setValue(int pin_num, bool value)
{
  if (!pinRegistered(pin_num))
  {
    std::cout << "Cannot set GPIO pin " << pin_num << " as it is not registered"
              << std::endl;
  }
  size_t num_chars;
  if (value)
  {
    num_chars = write(pin_map_[pin_num].valuefd, "1", 2);
  }
  else
  {
    num_chars = write(pin_map_[pin_num].valuefd, "0", 2);
  }

  if (0 >= num_chars)
  {
    std::cout << "Failed to write to pin " << pin_num << std::endl;
  }
}

bool GPIOChip::getValue(int pin_num)
{
  if (!pinRegistered(pin_num))
  {
    std::cout << "Cannot get GPIO pin " << pin_num << " as it is not registered"
              << std::endl;
  }

  size_t num_chars = read(pin_map_[pin_num].valuefd, num_buffer_, 2);
  if (0 >= num_chars)
  {
    std::cout << "Failed to read from pin " << pin_num << std::endl;
  }

  // If the number is 0 then false. Else, true.
  return !strcmp(num_buffer_, "0");
}
