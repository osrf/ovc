#include <vector>
#include <ovc4_driver/usb_packetdef.h>


class Camera
{
public:
  virtual bool initialise(int config_num) = 0;



};


// Picamera V2 with IMX 219 imager
class PiCameraV2 : public Camera
{
private:
  static constexpr uint8_t SLAVE_ADDR = 0x10;
  static constexpr uint8_t SUBADDR_SIZE = 0x2; // in bytes
  static constexpr uint8_t REG_SIZE = 0x1; // in bytes


  static constexpr uint16_t CHIP_ID_MSB_REGADDR = 0x0000;
  static constexpr uint16_t CHIP_ID_LSB_REGADDR = 0x0001;

  static constexpr uint16_t CHIP_ID = 0x0219;

  std::vector<std::vector<regop_t>> modes;

public:
  static void fillProbeRegOps(usb_txrx_i2c_t& probe_pkt);

  static bool checkProbeRegOps(usb_txrx_i2c_t& probe_pkt);

  virtual bool initialise(int config_num = 0) override;

};
