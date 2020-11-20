#include <iostream>
#include <unistd.h> // usleep

#include <ovc5_driver/cameras/picam_v2.hpp>

bool PiCameraV2::probe(I2CDriver *i2c)
{
  i2c->assignDevice(SLAVE_ADDR, REGISTER_SIZE);
  uint16_t chip_id = i2c->readRegister(CHIP_ID_LSB_REGADDR);
  chip_id |= i2c->readRegister(CHIP_ID_MSB_REGADDR) << 8;
  if (chip_id != CHIP_ID)
  {
    std::cout << "Picam v2 not found" << std::endl;
    return false;
  }
  std::cout << "Picam v2 detected" << std::endl;
  return true;
}

PiCameraV2::PiCameraV2(std::unique_ptr<I2CDriver> i2c) :
  I2CCamera(std::move(i2c))
{

}

bool PiCameraV2::initialise(const std::string& config_name)
{
  // Shouldn't be necessary if probe() was just called, repeat to be safe
  i2c->assignDevice(SLAVE_ADDR, REGISTER_SIZE);
  auto config = modes.find(config_name);
  if (config == modes.end())
    return false;
  reset();
  std::vector<regop_t> config_vec = common_ops;
  // Append specific configuration to common parameters
  config_vec.insert(config_vec.end(), config->second.begin(), config->second.end());
  // Now send the configuration
  for (const auto& conf : config_vec)
  {
    i2c->writeRegister(conf);
  }
  return true;
}

void PiCameraV2::enableStreaming()
{
  i2c->writeRegister(enable_streaming_regop);
}

void PiCameraV2::reset()
{
  i2c->writeRegister(reset_regop);
  // Wait a bit for reset to be finished
  usleep(10000);
}
