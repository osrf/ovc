#include <ovc4_driver/cameras/picam_v2.hpp>
#include <iostream>

static void init_i2c_pkt(usb_txrx_i2c_t& i2c_pkt)
{
  i2c_pkt.slave_address = PiCameraV2::SLAVE_ADDR;
  i2c_pkt.subaddress_size = PiCameraV2::SUBADDR_SIZE;
  i2c_pkt.register_size = PiCameraV2::REGISTER_SIZE;
}

void PiCameraV2::fillProbePkt(usb_txrx_i2c_t& i2c_pkt)
{
  init_i2c_pkt(i2c_pkt);
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
    probed_id |= ((uint16_t)i2c_pkt.regops[i].u8 << (i * 8));
  }
  if (probed_id != CHIP_ID)
    return false;
  return true;
}

camera_init_ret_t PiCameraV2::camera_init_config(usb_txrx_i2c_t& i2c_pkt)
{
  int num_op = 0;
  init_i2c_pkt(i2c_pkt);
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

bool PiCameraV2::set_config(const std::string& config_name)
{
  auto config = modes.find(config_name);
  if (config == modes.end())
    return false;
  // Start by uploading common, then matching configuration
  config_vec = common_ops;
  // Append the specific configuration operations
  config_vec.insert(config_vec.end(), config->second.begin(), config->second.end());
  config_it = config_vec.begin();
  config_ok = true;
  return true;
}

camera_init_ret_t PiCameraV2::initialise(const std::string& config_name, usb_txrx_i2c_t& i2c_pkt)
{
  if (!config_ok && !set_config(config_name))
    return camera_init_ret_t::CONFIG_NOT_FOUND;
  // We need a long sequence of i2c operations that might span multiple packets
  // The function returns IN_PROGRESS until all the operations have been done successfully
  return camera_init_config(i2c_pkt);
}

void PiCameraV2::enable_streaming(usb_txrx_i2c_t& i2c_pkt)
{
  init_i2c_pkt(i2c_pkt);
  i2c_pkt.regops[0] = enable_streaming_regop;
}

void PiCameraV2::reset(usb_txrx_i2c_t& i2c_pkt)
{
  init_i2c_pkt(i2c_pkt);
  i2c_pkt.regops[0] = reset_regop;
}
