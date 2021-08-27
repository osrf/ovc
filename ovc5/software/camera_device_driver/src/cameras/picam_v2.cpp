#include "ovc5_driver/cameras/picam_v2.hpp"

#include <unistd.h>  // usleep

#include <iostream>

const std::string DEFAULT_CAMERA_CONFIG = "1920x1080_30fps";

const camera_dynamic_configs_t dynamic_configs = {
    .frame_rate = false,
    .exposure = true,
};

const std::unordered_map<std::string, camera_params_t> camera_params_def = {
    {"3263x2564_21fps",
     {
         .res_x = 3263,
         .res_y = 2564,
         .fps = 21,
         .bit_depth = 10,
         // The data type cannot be defined as a string due to a compiler bug
         // resolved in GCC 11. See:
         // https://github.com/osrf/ovc/pull/59#discussion_r687052682
         .data_type = {'B', 'y', 'r', 'R', 'G', 'G', 'B', '\0'},
         .dynamic_configs = dynamic_configs,
     }},
    {"1920x1080_30fps",
     {
         .res_x = 1920,
         .res_y = 1080,
         .fps = 30,
         .bit_depth = 10,
         .data_type = {'B', 'y', 'r', 'R', 'G', 'G', 'B', '\0'},
         .dynamic_configs = dynamic_configs,
     }},
    {"1280x720_120fps",
     {
         .res_x = 1280,
         .res_y = 720,
         .fps = 120,
         .bit_depth = 10,
         .data_type = {'B', 'y', 'r', 'R', 'G', 'G', 'B', '\0'},
         .dynamic_configs = dynamic_configs,
     }},
};

// Common initialization operations
const std::vector<regop_t> common_ops_def = {
    /* sensor config */
    writeRegOp(0x0114, 0x01), /* D-Phy, 2-lane */
    writeRegOp(0x0128, 0x00),
    writeRegOp(0x012A, 0x18), /* 24 MHz INCK */
    writeRegOp(0x012B, 0x00),
    /* access code - vendor addr. ranges */
    writeRegOp(0x30EB, 0x05),
    writeRegOp(0x30EB, 0x0C),
    writeRegOp(0x300A, 0xFF),
    writeRegOp(0x300B, 0xFF),
    writeRegOp(0x30EB, 0x05),
    writeRegOp(0x30EB, 0x09),
    /* cis tuning */
    writeRegOp(0x455E, 0x00),
    writeRegOp(0x471E, 0x4B),
    writeRegOp(0x4767, 0x0F),
    writeRegOp(0x4750, 0x14),
    writeRegOp(0x4540, 0x00),
    writeRegOp(0x47B4, 0x14),
    writeRegOp(0x4713, 0x30),
    writeRegOp(0x478B, 0x10),
    writeRegOp(0x478F, 0x10),
    writeRegOp(0x4793, 0x10),
    writeRegOp(0x4797, 0x0E),
    writeRegOp(0x479B, 0x0E),
};

const std::unordered_map<std::string, std::vector<regop_t>> modes_def = {
    {"3263x2464_21fps",
     {
         writeRegOp(0x0157, 0x00), /* ANALOG_GAIN_GLOBAL[7:0] */
         writeRegOp(0x015A, 0x09), /* COARSE_INTEG_TIME[15:8] */
         writeRegOp(0x015B, 0xbd), /* COARSE_INTEG_TIME[7:0] */
         /* format settings */
         writeRegOp(0x0160, 0x09), /* FRM_LENGTH[15:8] */
         writeRegOp(0x0161, 0xC1), /* FRM_LENGTH[7:0] */
         writeRegOp(0x0162, 0x0D), /* LINE_LENGTH[15:8] */
         writeRegOp(0x0163, 0x78), /* LINE_LENGTH[7:0] */
         writeRegOp(0x0164, 0x00),
         writeRegOp(0x0165, 0x08),
         writeRegOp(0x0166, 0x0C),
         writeRegOp(0x0167, 0xC7),
         writeRegOp(0x0168, 0x00),
         writeRegOp(0x0169, 0x00),
         writeRegOp(0x016A, 0x09),
         writeRegOp(0x016B, 0x9F),
         writeRegOp(0x016C, 0x0C),
         writeRegOp(0x016D, 0xC0),
         writeRegOp(0x016E, 0x09),
         writeRegOp(0x016F, 0xA0),
         writeRegOp(0x0170, 0x01),
         writeRegOp(0x0171, 0x01),
         writeRegOp(0x0174, 0x00),
         writeRegOp(0x0175, 0x00),
         writeRegOp(0x018C, 0x0A),
         writeRegOp(0x018D, 0x0A),
         writeRegOp(0x0264, 0x00),
         writeRegOp(0x0265, 0x08),
         writeRegOp(0x0266, 0x0C),
         writeRegOp(0x0267, 0xC7),
         writeRegOp(0x026C, 0x0C),
         writeRegOp(0x026D, 0xC0),
         /* clock dividers */
         writeRegOp(0x0301, 0x05),
         writeRegOp(0x0303, 0x01),
         writeRegOp(0x0304, 0x03),
         writeRegOp(0x0305, 0x03),
         writeRegOp(0x0306, 0x00),
         writeRegOp(0x0307, 0x39),
         writeRegOp(0x0309, 0x0A),
         writeRegOp(0x030B, 0x01),
         writeRegOp(0x030C, 0x00),
         writeRegOp(0x030D, 0x72),
     }},
    {"1920x1080_30fps",
     {
         writeRegOp(0x0157, 0x00), /* ANALOG_GAIN_GLOBAL[7:0] */
         writeRegOp(0x015A, 0x06), /* COARSE_INTEG_TIME[15:8] */
         writeRegOp(0x015B, 0xde), /* COARSE_INTEG_TIME[7:0] */
         writeRegOp(0x0160, 0x06), /* FRM_LENGTH[15:8] */
         writeRegOp(0x0161, 0xE2), /* FRM_LENGTH[7:0] */
         writeRegOp(0x0162, 0x0D), /* LINE_LENGTH[15:8] */
         writeRegOp(0x0163, 0x78), /* LINE_LENGTH[7:0] */
         writeRegOp(0x0164, 0x02),
         writeRegOp(0x0165, 0xA8),
         writeRegOp(0x0166, 0x0A),
         writeRegOp(0x0167, 0x27),
         writeRegOp(0x0168, 0x02),
         writeRegOp(0x0169, 0xB4),
         writeRegOp(0x016A, 0x06),
         writeRegOp(0x016B, 0xEB),
         writeRegOp(0x016C, 0x07),
         writeRegOp(0x016D, 0x80),
         writeRegOp(0x016E, 0x04),
         writeRegOp(0x016F, 0x38),
         writeRegOp(0x0170, 0x01),
         writeRegOp(0x0171, 0x01),
         writeRegOp(0x0174, 0x00),
         writeRegOp(0x0175, 0x00),
         writeRegOp(0x018C, 0x0A),
         writeRegOp(0x018D, 0x0A),
         /* clocks dividers */
         writeRegOp(0x0301, 0x05),
         writeRegOp(0x0303, 0x01),
         writeRegOp(0x0304, 0x03),
         writeRegOp(0x0305, 0x03),
         writeRegOp(0x0306, 0x00),
         writeRegOp(0x0307, 0x39),
         writeRegOp(0x0309, 0x0A),
         writeRegOp(0x030B, 0x01),
         writeRegOp(0x030C, 0x00),
         writeRegOp(0x030D, 0x72),
         // Test pattern
         // writeRegOp(0x0600, 0x00),
         // writeRegOp(0x0601, 0x02),
     }},
    {"1280x720_120fps",
     {
         writeRegOp(0x0157, 0x00), /* ANALOG_GAIN_GLOBAL[7:0] */
         writeRegOp(0x015A, 0x01), /* COARSE_INTEG_TIME[15:8] */
         writeRegOp(0x015B, 0x85), /* COARSE_INTEG_TIME[7:0] */
         /* format settings */
         writeRegOp(0x0160, 0x01), /* FRM_LENGTH[15:8] */
         writeRegOp(0x0161, 0x89), /* FRM_LENGTH[7:0] */
         writeRegOp(0x0162, 0x0D), /* LINE_LENGTH[15:8] */
         writeRegOp(0x0163, 0xE8), /* LINE_LENGTH[7:0] */
         writeRegOp(0x0164, 0x01),
         writeRegOp(0x0165, 0x68),
         writeRegOp(0x0166, 0x0B),
         writeRegOp(0x0167, 0x67),
         writeRegOp(0x0168, 0x02),
         writeRegOp(0x0169, 0x00),
         writeRegOp(0x016A, 0x07),
         writeRegOp(0x016B, 0x9F),
         writeRegOp(0x016C, 0x05),
         writeRegOp(0x016D, 0x00),
         writeRegOp(0x016E, 0x02),
         writeRegOp(0x016F, 0xD0),
         writeRegOp(0x0170, 0x01),
         writeRegOp(0x0171, 0x01),
         writeRegOp(0x0174, 0x03),
         writeRegOp(0x0175, 0x03),
         writeRegOp(0x018C, 0x0A),
         writeRegOp(0x018D, 0x0A),
         /* clocks dividers */
         writeRegOp(0x0301, 0x05),
         writeRegOp(0x0303, 0x01),
         writeRegOp(0x0304, 0x03),
         writeRegOp(0x0305, 0x03),
         writeRegOp(0x0306, 0x00),
         writeRegOp(0x0307, 0x35),
         writeRegOp(0x0309, 0x0A),
         writeRegOp(0x030B, 0x01),
         writeRegOp(0x030C, 0x00),
         writeRegOp(0x030D, 0x66),
     }},
};

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
  modes = &modes_def;
  camera_params = &camera_params_def;
  common_ops = &common_ops_def;
}

bool PiCameraV2::initialise(std::string config_name)
{
  // Shouldn't be necessary if probe() was just called, repeat to be safe
  i2c.assignDevice(SLAVE_ADDR, REGISTER_SIZE);
  config_name =
      config_name == "__default__" ? DEFAULT_CAMERA_CONFIG : config_name;
  auto config = modes->find(config_name);
  if (config == modes->end()) return false;
  reset();
  std::vector<regop_t> config_vec = *common_ops;
  // Append specific configuration to common parameters
  config_vec.insert(
      config_vec.end(), config->second.begin(), config->second.end());
  // Now send the configuration
  for (const auto& conf : config_vec)
  {
    i2c.writeRegister(conf);
  }

  auto config_struct = camera_params->at(config_name);
  initVDMA(config_struct);

  t_max_ = 1.0f * config_struct.fps / 1000.0f;

  return true;
}

void PiCameraV2::enableStreaming()
{
  i2c.writeRegister(enable_streaming_regop);
}

/* Updates camera exposure time.
 *
 * As defined in the datasheet, the following computation is used to determine
 * exposure time:
 *
 */
void PiCameraV2::updateExposure(float ms)
{
  // VMAX is 18 bits starting at byte register 0x0000.
  uint16_t frame_length = (((uint16_t)i2c.readRegister(0x0160)) << 8 | i2c.readRegister(0x0161);
  uint16_t integration_time = static_cast<uint16_t>(
      std::clamp(ms * t_max_ * frame_length, 4.0f, frame_length - 8.0f));
  i2c.writeRegister(writeRegOp(0x018A, (uint8_t)(integration_time >> 8)));
  i2c.writeRegister(writeRegOp(0x018B, (uint8_t)integration_time));
}

void PiCameraV2::reset()
{
  i2c.writeRegister(reset_regop);
  // Wait a bit for reset to be finished
  usleep(10000);
}
