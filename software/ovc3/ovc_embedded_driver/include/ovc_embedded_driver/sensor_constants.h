#ifndef SENSOR_CONSTANTS_H
#define SENSOR_CONSTANTS_H

#include <string.h>

namespace ovc_embedded_driver
{
  constexpr size_t NUM_CAMERAS = 3;

  constexpr size_t RES_X = 1280;
  constexpr size_t RES_Y = 800;
  constexpr size_t IMAGE_SIZE = RES_X * RES_Y;

  typedef struct CameraHWParameters {
    int vdma_num;
    int i2c_num;
    std::string camera_name;
    bool is_rgb;

    CameraHWParameters(int vdma_device, int i2c_device, std::string name, bool rgb) : 
      vdma_num(vdma_device), i2c_num(i2c_device), camera_name(name), is_rgb(rgb) {}
  } CameraHWParameters;
}

#endif
