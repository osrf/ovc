#include <memory>
#include <optional>
#include <libusb.h>
#include <ovc4_driver/usb_packetdef.h>
#include <ovc4_driver/camera.hpp>

class USBDriver
{
  const int EP_IN = 0x81;
  const int EP_OUT = 0x01;

  const int RX_TIMEOUT = 1000; // 1 second

  libusb_device_handle *dev_handle;

public:
  USBDriver();

  usb_rx_packet_t initRegopPacket();

  bool sendPacket(usb_rx_packet_t& packet);

  std::optional<usb_tx_packet_t> pollData();

  // Used for I2C transactions, the result can be checked for NAKs
  std::optional<usb_tx_packet_t> sendAndPoll(usb_rx_packet_t& packet);
};
