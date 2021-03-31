#include <ovc4_driver/cameras/picam_hq.hpp>


static void init_i2c_pkt(usb_txrx_i2c_t& i2c_pkt)
{
  i2c_pkt.slave_address = PiCameraHQ::SLAVE_ADDR;
  i2c_pkt.subaddress_size = PiCameraHQ::SUBADDR_SIZE;
  i2c_pkt.register_size = PiCameraHQ::REGISTER_SIZE;
}

void PiCameraHQ::fillProbePkt(usb_txrx_i2c_t& i2c_pkt)
{
  init_i2c_pkt(i2c_pkt);
  // Read the two register IDs
  i2c_pkt.regops[0].addr = CHIP_ID_LSB_REGADDR;
  i2c_pkt.regops[0].status = REGOP_READ;
  i2c_pkt.regops[1].addr = CHIP_ID_MSB_REGADDR;
  i2c_pkt.regops[1].status = REGOP_READ;
}

bool PiCameraHQ::checkProbePkt(usb_txrx_i2c_t& i2c_pkt)
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

sensor_type_t PiCameraHQ::getType() const
{
  return sensor_type_t::PiCameraHQ;
}

// TODO move this to base class (common to all cameras)
camera_init_ret_t PiCameraHQ::camera_init_config(usb_txrx_i2c_t& i2c_pkt)
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

bool PiCameraHQ::set_config(const std::string& config_name)
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

camera_init_ret_t PiCameraHQ::initialise(const std::string& config_name, usb_txrx_i2c_t& i2c_pkt)
{
  if (!config_ok && !set_config(config_name))
    return camera_init_ret_t::CONFIG_NOT_FOUND;
  // We need a long sequence of i2c operations that might span multiple packets
  // The function returns IN_PROGRESS until all the operations have been done successfully
  return camera_init_config(i2c_pkt);
}

void PiCameraHQ::enableStreaming(usb_txrx_i2c_t& i2c_pkt)
{
  init_i2c_pkt(i2c_pkt);
  i2c_pkt.regops[0] = enable_streaming_regop;
}

void PiCameraHQ::updateExposure(usb_txrx_i2c_t& i2c_pkt)
{
  // TODO caching gain and exposure to avoid sending when not necessary
  // TODO cache frame length
  // TODO all these properties from sysfs
  int64_t frame_length_raw = uio->getFrameLength();
  frame_length = (PIXEL_CLOCK * FRAMERATE_FACTOR /
      LINE_LENGTH / frame_length_raw);

  int64_t exposure_raw = uio->getExposure();
  int32_t max_coarse_time = frame_length - MAX_COARSE_DIFF;
  // TODO fine time contribution
  //int32_t fine_integ_time_factor = fine_integ_time *
  //  EXPOSURE_FACTOR / PIXEL_CLOCK;

  //uint32_t coarse_time = (exposure_raw - fine_integ_time_factor) *
  uint32_t coarse_time = (exposure_raw) *
    PIXEL_CLOCK / EXPOSURE_FACTOR / LINE_LENGTH;

  if (coarse_time < MIN_COARSE_EXPOSURE)
    coarse_time = MIN_COARSE_EXPOSURE;
  else if (coarse_time > max_coarse_time)
    coarse_time = max_coarse_time;
  // Convert to registers

  int64_t gain_raw = uio->getGain();
  // Translate gain
  int16_t gain = (int16_t)((1024 * GAIN_FACTOR) / gain_raw);
  gain = 1024 - gain;
  if (gain < MIN_GAIN)
    gain = MIN_GAIN;
  else if (gain > MAX_GAIN)
    gain = MAX_GAIN;
  // Set the packets
  init_i2c_pkt(i2c_pkt);
  i2c_pkt.regops[0].addr = COARSE_TIME_MSB_REGADDR;
  i2c_pkt.regops[0].u8 = (coarse_time >> 8) & 0x03; // Only get two bits
  i2c_pkt.regops[0].status = REGOP_WRITE;
  i2c_pkt.regops[1].addr = COARSE_TIME_LSB_REGADDR;
  i2c_pkt.regops[1].u8 = (coarse_time) & 0xFF;
  i2c_pkt.regops[1].status = REGOP_WRITE;
  i2c_pkt.regops[2].addr = GAIN_REGADDR;
  i2c_pkt.regops[2].u8 = (gain) & 0xFF;
  i2c_pkt.regops[2].status = REGOP_WRITE;
}

void PiCameraHQ::reset(usb_txrx_i2c_t& i2c_pkt)
{
  init_i2c_pkt(i2c_pkt);
  i2c_pkt.regops[0] = reset_regop;
}
