//#include <gpiod.h>

#include <iostream>

#include "cameras/ar0234.hpp"

// GPIO guided by:
// https://embeddedbits.org/new-linux-kernel-gpio-user-space-interface/
// void enable_cam(int chip_num, int gpio_num)
//{
//  struct gpiod_chip *chip;
//  struct gpiod_line *line;
//  int req, value;
//
//  chip = gpiod_chip_open("/dev/gpiochip0");
//  if (!chip) return -1;
//
//  line = gpiod_chip_get_line(chip, 3);
//  if (!line)
//  {
//    gpiod_chip_close(chip);
//    return -1;
//  }
//
//  req = gpiod_line_request_input(line, "gpio_state");
//  if (req)
//  {
//    gpiod_chip_close(chip);
//    return -1;
//  }
//
//  value = gpiod_line_get_value(line);
//
//  printf("GPIO value is: %d\n", value);
//
//  gpiod_chip_close(chip);
//}

int main()
{
  I2CDriver driver(2);
  AR0234 camera(driver, true);

  // Cam1 enable is pin 17 which is gpiochip4[25] according to the datasheet.
  // This is an input pin. On converter board, connect to pin 24 which is
  // IO_CAMOut0. This connects to P15 on the QSXP/M. To note, there is a level
  // shifter from 3v3 (module voltage) to 1v8 (camera IO voltage). For
  // prototyping, it is easier to just connect cam enable to the 3v3 line on
  // the converter board and cut the trace heading back to the QSBase3.

  bool cam_available = camera.probe(driver);

  std::cout << "Camera is " << (cam_available ? "available" : "not available")
            << std::endl;
  if (cam_available) {
    camera.initialise(std::string("1920x1200_60fps"));
    camera.enableStreaming();
  }
}
