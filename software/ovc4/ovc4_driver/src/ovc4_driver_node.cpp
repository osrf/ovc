#include <ros/ros.h>
#include <ovc4_driver/usb_driver.hpp>

#include <sensor_msgs/Imu.h>


int main(int argc, char **argv)
{
  ros::init(argc, argv, "ovc4_driver_node");
  // TODO local nodehandle
  ros::NodeHandle nh;
  // Imu publisher
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("imu", 10);
  USBDriver usb;
  // Probe imagers then publish IMU data
  ros::Rate loop_rate(10000);
  usb.probeImagers();
  while (ros::ok())
  {
    // Poll at 1kHz
    auto rx_data = usb.pollData();
    sensor_msgs::Imu imu_msg;
    imu_msg.header.stamp = ros::Time::now();
    imu_msg.linear_acceleration.x = rx_data.imu.acc_x;
    imu_msg.linear_acceleration.y = rx_data.imu.acc_y;
    imu_msg.linear_acceleration.z = rx_data.imu.acc_z;
    imu_msg.angular_velocity.x = rx_data.imu.gyro_x;
    imu_msg.angular_velocity.y = rx_data.imu.gyro_y;
    imu_msg.angular_velocity.z = rx_data.imu.gyro_z;
    imu_pub.publish(imu_msg);
    //ROS_INFO("Temperature = %.2f", rx_data.imu.temperature);
    loop_rate.sleep();
  }
}
