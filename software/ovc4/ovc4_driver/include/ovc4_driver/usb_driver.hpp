#include <memory>
#include <libusb.h>
#include <ovc4_driver/usb_packetdef.h>
#include <ovc4_driver/camera.hpp>

class USBDriver
{
  const int EP_IN = 0x81;
  const int EP_OUT = 0x01;

  const int RX_TIMEOUT = 1000; // 1 second

  libusb_device_handle *dev_handle;

  std::array<std::shared_ptr<Camera>, NUM_CAMERAS> cameras;
  
  void sendPacket(usb_rx_packet_t& packet);

  usb_rx_packet_t initRegopPacket();

  void initCamera(int cam_id, const std::string& config_name);

public:

  USBDriver();

  usb_tx_packet_t pollData();

  void probeImagers();
};
