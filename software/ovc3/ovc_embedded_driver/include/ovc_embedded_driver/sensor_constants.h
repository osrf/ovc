#ifndef SENSOR_CONSTANTS_H
#define SENSOR_CONSTANTS_H

#include <string.h>

namespace ovc_embedded_driver
{
  constexpr size_t NUM_CAMERAS = 3;
  constexpr size_t EXTERNAL_BOARDS = 2;

  constexpr size_t RES_X = 1280;
  constexpr size_t RES_Y = 800;
  constexpr size_t IMAGE_SIZE = RES_X * RES_Y;

  typedef struct CameraHWParameters {
    int vdma_dev;
    int i2c_dev;
    int i2c_lsb;
    std::string camera_name;
    bool is_rgb;

    CameraHWParameters(int vdma_device, int i2c_device, int i2c_l, std::string name, bool rgb) :
      vdma_dev(vdma_device), i2c_dev(i2c_device), i2c_lsb(i2c_l), camera_name(name), is_rgb(rgb) {}
  } CameraHWParameters;
}

#endif
