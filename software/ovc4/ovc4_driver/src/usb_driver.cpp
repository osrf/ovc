#include <ros/ros.h>
#include <ovc4_driver/usb_driver.hpp>
#include <ovc4_driver/usb_packetdef.h>

USBDriver::USBDriver()
{
  // Get a list of usb devices
  libusb_device **devices;
  // Single device
  libusb_context *ctx = NULL;
  if (libusb_init(&ctx) < 0)
    ROS_ERROR("Initialization error");

  libusb_set_debug(ctx, 3); // Verbosity lvl 3

  ssize_t num_devices = libusb_get_device_list(ctx, &devices);
  if (num_devices < 0)
    ROS_ERROR("Error in get devices");

  dev_handle = libusb_open_device_with_vid_pid(ctx, USB_VID, USB_PID);
  if (dev_handle == NULL)
    ROS_ERROR("Device not found");

  libusb_free_device_list(devices, 1);

  // Detach kernel driver
  if (libusb_kernel_driver_active(dev_handle, 0) == 1)
    if (libusb_detach_kernel_driver(dev_handle, 0) == 0)
      ROS_INFO("Kernel driver detached");
  if (libusb_claim_interface(dev_handle, 0) < 0)
    ROS_ERROR("Failed to claim interface");
}

std::optional<usb_tx_packet_t> USBDriver::pollData()
{
  // Bit misleading naming, tx (from MCU) rx (from host machine)
  usb_tx_packet_t rx_packet;
  int num_bytes;
  
  int ret_val = libusb_bulk_transfer(dev_handle, EP_IN, rx_packet.data, sizeof(rx_packet), &num_bytes, RX_TIMEOUT);
  if (ret_val == 0)
    return rx_packet;
  return {};
}

// libusb function uses a non const pointer so we cannot pass const reference
bool USBDriver::sendPacket(usb_rx_packet_t& packet)
{
  int num_bytes;
  int ret_val = libusb_bulk_transfer(dev_handle, EP_OUT, packet.data, sizeof(packet), &num_bytes, RX_TIMEOUT);
  if (ret_val != 0)
  {
    std::cout << "Send packet failed" << std::endl;
    return false;
  }
  return true;
}

usb_rx_packet_t USBDriver::initRegopPacket()
{
  usb_rx_packet_t regops_pkt = {};
  regops_pkt.packet_type = RX_PACKET_TYPE_I2C_SEQUENTIAL;
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
    for (int regop_id = 0; regop_id < REGOPS_PER_CAM; ++regop_id)
      regops_pkt.i2c[cam_id].regops[regop_id].status = REGOP_INVALID;
  return regops_pkt;
}

void USBDriver::setImagersEnable(bool enable)
{
  // TODO implement
}

std::optional<usb_tx_packet_t> USBDriver::sendAndPoll(usb_rx_packet_t& packet)
{
  sendPacket(packet);
  return pollData();
}
