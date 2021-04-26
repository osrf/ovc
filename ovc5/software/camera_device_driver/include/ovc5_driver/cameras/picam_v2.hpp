/*
 * Copyright (C) 2020 Open Source Robotics Foundation
 *
 * Camera description and initialization for Picam V2 (imx219).
 *
 * Register information taken from:
 * imx219_tables.h - sensor mode tables for imx219 HDR sensor.
 *
 * Copyright (c) 2015-2019, NVIDIA CORPORATION, All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef CAMERAS__PICAM_V2_INC
#define CAMERAS__PICAM_V2_INC
#include <memory>
#include <unordered_map>
#include <vector>

#include "ovc5_driver/camera.hpp"

// Picamera V2 with IMX 219 imager
class PiCameraV2 : public I2CCamera
{
private:
  const std::string DEFAULT_CAMERA_CONFIG = "1920x1080_30fps";

  static constexpr uint16_t CHIP_ID_MSB_REGADDR = 0x0000;
  static constexpr uint16_t CHIP_ID_LSB_REGADDR = 0x0001;

  static constexpr uint16_t COARSE_TIME_MSB_REGADDR = 0x015A;
  static constexpr uint16_t COARSE_TIME_LSB_REGADDR = 0x015B;
  static constexpr uint16_t GAIN_REGADDR = 0x0157;

  static constexpr uint16_t CHIP_ID = 0x0219;

  static constexpr int16_t MAX_COARSE_DIFF = 0x0004;
  static constexpr int16_t MIN_COARSE_EXPOSURE = 0x0001;

  static constexpr int16_t MIN_GAIN = 0x0000;
  static constexpr int16_t MAX_GAIN = 0x00E8;
  // TODO those from device tree
  static constexpr int32_t PIXEL_CLOCK = 182400000;
  static constexpr int32_t FRAMERATE_FACTOR = 1000000;
  static constexpr int32_t LINE_LENGTH = 3448;
  static constexpr int32_t EXPOSURE_FACTOR = 1000000;
  static constexpr int32_t GAIN_FACTOR = 16;

  const regop_t enable_streaming_regop = writeRegOp(0x0100, 0x01);

  const regop_t reset_regop = writeRegOp(0x0103, 0x01);

  // Common initialization operations
  const std::vector<regop_t> common_ops = {
      /* sensor config */
      writeRegOp(0x0114, 0x01),                           /* D-Phy, 2-lane */
      writeRegOp(0x0128, 0x00), writeRegOp(0x012A, 0x18), /* 24 MHz INCK */
      writeRegOp(0x012B, 0x00),
      /* access code - vendor addr. ranges */
      writeRegOp(0x30EB, 0x05), writeRegOp(0x30EB, 0x0C),
      writeRegOp(0x300A, 0xFF), writeRegOp(0x300B, 0xFF),
      writeRegOp(0x30EB, 0x05), writeRegOp(0x30EB, 0x09),
      /* cis tuning */
      writeRegOp(0x455E, 0x00), writeRegOp(0x471E, 0x4B),
      writeRegOp(0x4767, 0x0F), writeRegOp(0x4750, 0x14),
      writeRegOp(0x4540, 0x00), writeRegOp(0x47B4, 0x14),
      writeRegOp(0x4713, 0x30), writeRegOp(0x478B, 0x10),
      writeRegOp(0x478F, 0x10), writeRegOp(0x4793, 0x10),
      writeRegOp(0x4797, 0x0E), writeRegOp(0x479B, 0x0E)};

  const std::unordered_map<std::string, camera_params_t> camera_params = {
      {"3263x2564_21fps",
       {
           .res_x = 3263,
           .res_y = 2564,
           .fps = 21,
           .bit_depth = 10,
       }},
      {"1920x1080_30fps",
       {
           .res_x = 1920,
           .res_y = 1080,
           .fps = 30,
           .bit_depth = 10,
       }},
      {"1280x720_120fps",
       {
           .res_x = 1280,
           .res_y = 720,
           .fps = 120,
           .bit_depth = 10,
       }},
  };

  const std::unordered_map<std::string, std::vector<regop_t>> modes = {
      {"3263x2464_21fps",
       {writeRegOp(0x0157, 0x00), /* ANALOG_GAIN_GLOBAL[7:0] */
        writeRegOp(0x015A, 0x09), /* COARSE_INTEG_TIME[15:8] */
        writeRegOp(0x015B, 0xbd), /* COARSE_INTEG_TIME[7:0] */
        /* format settings */
        writeRegOp(0x0160, 0x09), /* FRM_LENGTH[15:8] */
        writeRegOp(0x0161, 0xC1), /* FRM_LENGTH[7:0] */
        writeRegOp(0x0162, 0x0D), /* LINE_LENGTH[15:8] */
        writeRegOp(0x0163, 0x78), /* LINE_LENGTH[7:0] */
        writeRegOp(0x0164, 0x00), writeRegOp(0x0165, 0x08),
        writeRegOp(0x0166, 0x0C), writeRegOp(0x0167, 0xC7),
        writeRegOp(0x0168, 0x00), writeRegOp(0x0169, 0x00),
        writeRegOp(0x016A, 0x09), writeRegOp(0x016B, 0x9F),
        writeRegOp(0x016C, 0x0C), writeRegOp(0x016D, 0xC0),
        writeRegOp(0x016E, 0x09), writeRegOp(0x016F, 0xA0),
        writeRegOp(0x0170, 0x01), writeRegOp(0x0171, 0x01),
        writeRegOp(0x0174, 0x00), writeRegOp(0x0175, 0x00),
        writeRegOp(0x018C, 0x0A), writeRegOp(0x018D, 0x0A),
        writeRegOp(0x0264, 0x00), writeRegOp(0x0265, 0x08),
        writeRegOp(0x0266, 0x0C), writeRegOp(0x0267, 0xC7),
        writeRegOp(0x026C, 0x0C), writeRegOp(0x026D, 0xC0),
        /* clock dividers */
        writeRegOp(0x0301, 0x05), writeRegOp(0x0303, 0x01),
        writeRegOp(0x0304, 0x03), writeRegOp(0x0305, 0x03),
        writeRegOp(0x0306, 0x00), writeRegOp(0x0307, 0x39),
        writeRegOp(0x0309, 0x0A), writeRegOp(0x030B, 0x01),
        writeRegOp(0x030C, 0x00), writeRegOp(0x030D, 0x72)}},
      {"1920x1080_30fps",
       {
           writeRegOp(0x0157, 0x00), /* ANALOG_GAIN_GLOBAL[7:0] */
           writeRegOp(0x015A, 0x06), /* COARSE_INTEG_TIME[15:8] */
           writeRegOp(0x015B, 0xde), /* COARSE_INTEG_TIME[7:0] */
           writeRegOp(0x0160, 0x06), /* FRM_LENGTH[15:8] */
           writeRegOp(0x0161, 0xE2), /* FRM_LENGTH[7:0] */
           writeRegOp(0x0162, 0x0D), /* LINE_LENGTH[15:8] */
           writeRegOp(0x0163, 0x78), /* LINE_LENGTH[7:0] */
           writeRegOp(0x0164, 0x02), writeRegOp(0x0165, 0xA8),
           writeRegOp(0x0166, 0x0A), writeRegOp(0x0167, 0x27),
           writeRegOp(0x0168, 0x02), writeRegOp(0x0169, 0xB4),
           writeRegOp(0x016A, 0x06), writeRegOp(0x016B, 0xEB),
           writeRegOp(0x016C, 0x07), writeRegOp(0x016D, 0x80),
           writeRegOp(0x016E, 0x04), writeRegOp(0x016F, 0x38),
           writeRegOp(0x0170, 0x01), writeRegOp(0x0171, 0x01),
           writeRegOp(0x0174, 0x00), writeRegOp(0x0175, 0x00),
           writeRegOp(0x018C, 0x0A), writeRegOp(0x018D, 0x0A),
           /* clocks dividers */
           writeRegOp(0x0301, 0x05), writeRegOp(0x0303, 0x01),
           writeRegOp(0x0304, 0x03), writeRegOp(0x0305, 0x03),
           writeRegOp(0x0306, 0x00), writeRegOp(0x0307, 0x39),
           writeRegOp(0x0309, 0x0A), writeRegOp(0x030B, 0x01),
           writeRegOp(0x030C, 0x00), writeRegOp(0x030D, 0x72),
           // Test pattern
           // writeRegOp(0x0600, 0x00),
           // writeRegOp(0x0601, 0x02),
       }},
      {"1280x720_120fps",
       {writeRegOp(0x0157, 0x00), /* ANALOG_GAIN_GLOBAL[7:0] */
        writeRegOp(0x015A, 0x01), /* COARSE_INTEG_TIME[15:8] */
        writeRegOp(0x015B, 0x85), /* COARSE_INTEG_TIME[7:0] */
        /* format settings */
        writeRegOp(0x0160, 0x01), /* FRM_LENGTH[15:8] */
        writeRegOp(0x0161, 0x89), /* FRM_LENGTH[7:0] */
        writeRegOp(0x0162, 0x0D), /* LINE_LENGTH[15:8] */
        writeRegOp(0x0163, 0xE8), /* LINE_LENGTH[7:0] */
        writeRegOp(0x0164, 0x01), writeRegOp(0x0165, 0x68),
        writeRegOp(0x0166, 0x0B), writeRegOp(0x0167, 0x67),
        writeRegOp(0x0168, 0x02), writeRegOp(0x0169, 0x00),
        writeRegOp(0x016A, 0x07), writeRegOp(0x016B, 0x9F),
        writeRegOp(0x016C, 0x05), writeRegOp(0x016D, 0x00),
        writeRegOp(0x016E, 0x02), writeRegOp(0x016F, 0xD0),
        writeRegOp(0x0170, 0x01), writeRegOp(0x0171, 0x01),
        writeRegOp(0x0174, 0x03), writeRegOp(0x0175, 0x03),
        writeRegOp(0x018C, 0x0A), writeRegOp(0x018D, 0x0A),
        /* clocks dividers */
        writeRegOp(0x0301, 0x05), writeRegOp(0x0303, 0x01),
        writeRegOp(0x0304, 0x03), writeRegOp(0x0305, 0x03),
        writeRegOp(0x0306, 0x00), writeRegOp(0x0307, 0x35),
        writeRegOp(0x0309, 0x0A), writeRegOp(0x030B, 0x01),
        writeRegOp(0x030C, 0x00), writeRegOp(0x030D, 0x66)}}};

  std::vector<regop_t>::const_iterator config_it;
  std::vector<regop_t> config_vec;

  uint32_t frame_length;

  bool config_ok = false;

  // camera_init_ret_t camera_init_config(usb_txrx_i2c_t& i2c_pkt);

public:
  // Used in external function
  static constexpr uint8_t SLAVE_ADDR = 0x10;
  static constexpr uint8_t SUBADDR_SIZE = 0x2;   // in bytes
  static constexpr uint8_t REGISTER_SIZE = 0x1;  // in bytes

  static bool probe(I2CDriver& i2c);

  PiCameraV2(I2CDriver& i2c, int vdma_dev, int cam_id, bool main_camera);

  // virtual sensor_type_t getType() const override;

  virtual bool initialise(std::string config_name) override;

  virtual void enableStreaming() override;

  // virtual void updateExposure(usb_txrx_i2c_t& i2c_pkt) override;

  virtual void reset() override;
};
#endif
