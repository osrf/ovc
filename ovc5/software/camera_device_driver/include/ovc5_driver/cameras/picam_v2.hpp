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

  const std::vector<regop_t>* common_ops;
  const std::unordered_map<std::string, camera_params_t>* camera_params;
  const std::unordered_map<std::string, std::vector<regop_t>>* modes;

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
