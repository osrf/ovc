#include <unistd.h>  // usleep

#include <iostream>
#include "ovc5_driver/cameras/picam_v2.hpp"

bool PiCameraV2::probe(I2CDriver& i2c)
{
  i2c.assignDevice(SLAVE_ADDR, REGISTER_SIZE);
  uint16_t chip_id = i2c.readRegister(CHIP_ID_LSB_REGADDR);
  chip_id |= i2c.readRegister(CHIP_ID_MSB_REGADDR) << 8;
  if (chip_id != CHIP_ID)
  {
    std::cout << "Picam v2 not found" << std::endl;
    return false;
  }
  std::cout << "Picam v2 detected" << std::endl;
  return true;
}

PiCameraV2::PiCameraV2(I2CDriver& i2c, int vdma_dev, int cam_id,
                       bool main_camera)
    : I2CCamera(i2c, vdma_dev, cam_id, main_camera)
{
}

bool PiCameraV2::initialise(std::string config_name)
{
  // Shouldn't be necessary if probe() was just called, repeat to be safe
  i2c.assignDevice(SLAVE_ADDR, REGISTER_SIZE);
  config_name =
      config_name == "__default__" ? DEFAULT_CAMERA_CONFIG : config_name;
  auto config = modes.find(config_name);
  if (config == modes.end()) return false;
  reset();
  std::vector<regop_t> config_vec = common_ops;
  // Append specific configuration to common parameters
  config_vec.insert(config_vec.end(), config->second.begin(),
                    config->second.end());
  // Now send the configuration
  for (const auto& conf : config_vec)
  {
    i2c.writeRegister(conf);
  }
  initVDMA(camera_params.at(config_name));
  return true;
}

void PiCameraV2::enableStreaming()
{
  i2c.writeRegister(enable_streaming_regop);
}

void PiCameraV2::reset()
{
  i2c.writeRegister(reset_regop);
  // Wait a bit for reset to be finished
  usleep(10000);
}
