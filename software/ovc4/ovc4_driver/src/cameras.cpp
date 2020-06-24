#include <ovc4_driver/cameras.hpp>


void PiCameraV2::fillProbeRegOps(usb_txrx_i2c_t& i2c_pkt)
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

bool PiCameraV2::checkProbeRegOps(usb_txrx_i2c_t& i2c_pkt)
{
  uint16_t probed_id = 0;
  for (int i = 0; i < 2; ++i)
  {
    // NAK reply
    if (i2c_pkt.regops[i].status != REGOP_NAK)
      return false;
    probed_id |= (i2c_pkt.regops[i].u8 << (i * 8));
  }
  if (probed_id != CHIP_ID)
    return false;
  return true;
}

bool PiCameraV2::initialise(int config_num)
{
  // We need a long sequence of i2c operations that might span multiple packets
  // The function returns false until all the operations have been done successfully

}
