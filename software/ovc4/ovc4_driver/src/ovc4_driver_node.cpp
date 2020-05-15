#include <ros/ros.h>
#include <ovc4_driver/usb_driver.h>



int main(int argc, char **argv)
{
  ROS_INFO("Hello world");
  ros::init(argc, argv, "ovc4_driver_node");
  ros::NodeHandle nh;
  USBDriver usb;
  // Send calibration read command
  ros::Rate loop_rate(1000);
  //usb.sendPacket();
  usb.probeImagers();
  while (ros::ok())
  {
    // Poll at 1kHz
    usb.pollData();
    loop_rate.sleep();
  }
}
