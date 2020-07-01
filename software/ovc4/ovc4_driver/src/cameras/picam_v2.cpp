#include <ovc4_driver/cameras/picam_v2.hpp>
#include <iostream>


void PiCameraV2::fillProbePkt(usb_txrx_i2c_t& i2c_pkt)
{
  // I2C address
  i2c_pkt.slave_address = SLAVE_ADDR;
  i2c_pkt.subaddress_size = 2;
  i2c_pkt.register_size = 1;
  // Read the two register IDs
  i2c_pkt.regops[0].addr = CHIP_ID_LSB_REGADDR;
  i2c_pkt.regops[0].status = REGOP_READ;
  i2c_pkt.regops[1].addr = CHIP_ID_MSB_REGADDR;
  i2c_pkt.regops[1].status = REGOP_READ;
}

bool PiCameraV2::checkProbePkt(usb_txrx_i2c_t& i2c_pkt)
{
  uint16_t probed_id = 0;
  for (int i = 0; i < 2; ++i)
  {
    // NAK reply
    if (i2c_pkt.regops[i].status != REGOP_OK)
      return false;
    probed_id |= (i2c_pkt.regops[i].u16 << (i * 8));
  }
  if (probed_id != CHIP_ID)
    return false;
  return true;
}

camera_init_ret_t PiCameraV2::camera_init_common(usb_txrx_i2c_t& i2c_pkt)
{
  int num_op = 0;
  while (common_it != common_ops.end() && num_op < REGOPS_PER_CAM)
  {
    i2c_pkt.regops[num_op] = *common_it;
    ++common_it;
    ++num_op;
  }
  if (common_it != common_ops.end())
    return camera_init_ret_t::IN_PROGRESS;
  return camera_init_ret_t::DONE;
}

camera_init_ret_t PiCameraV2::camera_init_config(usb_txrx_i2c_t& i2c_pkt, const std::string& config_name)
{
  auto config_vec = modes.find(config_name)->second;
  int num_op = 0;
  while (config_it != config_vec.end() && num_op < REGOPS_PER_CAM)
  {
    i2c_pkt.regops[num_op] = *config_it;
    ++config_it;
    ++num_op;
  }
  if (config_it != config_vec.end())
    return camera_init_ret_t::IN_PROGRESS;
  return camera_init_ret_t::DONE;
}

camera_init_ret_t PiCameraV2::initialise(const std::string& config_name, usb_txrx_i2c_t& i2c_pkt)
{
  // We need a long sequence of i2c operations that might span multiple packets
  // The function returns false until all the operations have been done successfully
  auto config = modes.find(config_name);
  if (config == modes.end())
    return camera_init_ret_t::CONFIG_NOT_FOUND;
  // Start by uploading common, then matching configuration
  common_it = common_ops.begin();
  config_it = config->second.begin();
  auto common_ret = camera_init_common(i2c_pkt);
  if (common_ret != camera_init_ret_t::DONE)
    return common_ret;
  return camera_init_config(i2c_pkt, config_name);
}
