#include <libusb.h>
#include <ovc4_driver/usb_packetdef.h>

class USBDriver
{
  const int EP_IN = 0x82;
  const int EP_OUT = 0x03;

  const int RX_TIMEOUT = 1000; // 1 second

  libusb_device_handle *dev_handle;

  usb_tx_packet_t rx_packet;

public:

  USBDriver();

  void pollData();

};
