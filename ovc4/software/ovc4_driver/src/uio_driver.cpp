#include <iostream>
#include <fcntl.h>
#include <sys/mman.h>

#include <ovc4_driver/uio_driver.hpp>


UIODriver::UIODriver(int num)
{
  std::cout << "Creating uio file" << std::endl;
  std::string uio_filename = "/dev/uio" + std::to_string(num);
  uio_file = open(uio_filename.c_str(), O_RDWR);
  uio_mmap = (uio_map *) mmap(NULL, sizeof(struct uio_map), PROT_READ | PROT_WRITE, MAP_SHARED, uio_file, 0);
  if (uio_file < 0)
    std::cout << "Failed to open uio file " << num << std::endl;
}

uint32_t UIODriver::getSensorId() const
{
  return uio_mmap->sensor_id;
}

int64_t UIODriver::getGain() const
{
  return uio_mmap->gain;
}

int64_t UIODriver::getExposure() const
{
  return uio_mmap->exposure;
}

int64_t UIODriver::getFrameLength() const
{
  return uio_mmap->frame_length;
}

int64_t UIODriver::getExposureShort() const
{
  return uio_mmap->exposure_short;
}
