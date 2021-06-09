#include "ovc5_driver/gpio_driver.hpp"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <iostream>
#include <string>
#include <cstring>

bool GPIOChip::pinRegistered(int pin_num)
{
  return !(pin_map_.find(pin_num) == pin_map_.end());
}

bool GPIOChip::openPin(int pin_num, int direction)
{
  if (pinRegistered(pin_num))
  {
    return true;
  }

  int exportfd, directionfd;
  gpio_pin_config_t config;

  // The GPIO has to be exported to be able to see it in sysfs.
  exportfd = open((std::string(GPIO_SYSFS_PATH) + "/export").c_str(), O_WRONLY);
  if (exportfd < 0)
  {
    std::cout << "Cannot open GPIO export fd" << std::endl;
    return false;
  }

  if (chip_num_ + pin_num > 999)
  {
    std::cout << "Cannot export GPIO, pin number too long" << std::endl;
  }
  // Offset the chip num by the pin number and convert it to a string.
  sprintf(num_buffer_, "%d", chip_num_ + pin_num);
  write(exportfd, num_buffer_, GPIO_NAME_SIZE);
  close(exportfd);

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
    write(directionfd, "out", 4);
  }
  else
  {
    write(directionfd, "in", 3);
  }
  close(directionfd);

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
  if (!pinRegistered(pin_num))
  {
    return;
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
  if (value)
  {
    write(pin_map_[pin_num].valuefd, "1", 2);
  }
  else
  {
    write(pin_map_[pin_num].valuefd, "0", 2);
  }
}

bool GPIOChip::getValue(int pin_num)
{
  if (!pinRegistered(pin_num))
  {
    std::cout << "Cannot get GPIO pin " << pin_num << " as it is not registered"
              << std::endl;
  }

  read(pin_map_[pin_num].valuefd, num_buffer_, 2);

  // If the number is 0 then false. Else, true.
  return !strcmp(num_buffer_, "0");
}
