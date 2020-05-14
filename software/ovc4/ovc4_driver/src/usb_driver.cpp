#include <ros/ros.h>
#include <ovc4_driver/usb_driver.h>
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

void USBDriver::pollData()
{
  int num_bytes;
  static int rx_pkts = 0;
  
  int ret_val = libusb_bulk_transfer(dev_handle, EP_IN, rx_packet.data, sizeof(rx_packet), &num_bytes, RX_TIMEOUT);
  if (ret_val == 0)
  {
    ROS_INFO("Status is %d", rx_packet.header.status);
    ++rx_pkts;
    ROS_INFO("Received %d packets", rx_pkts);
  }
}

void USBDriver::sendPacket()
{
  usb_rx_packet_t tx_packet;
  tx_packet.header.status = 1337;
  int num_bytes;
  int ret_val = libusb_bulk_transfer(dev_handle, EP_OUT, tx_packet.data, sizeof(tx_packet), &num_bytes, RX_TIMEOUT);
  if (ret_val != 0)
  {
    ROS_INFO("Send packet failed");
  }
}
