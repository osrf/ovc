#include <ros/ros.h>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <ovc4_driver/sensor_manager.hpp>

#include <sensor_msgs/Imu.h>
#include <sensor_msgs/Image.h>


int main(int argc, char **argv)
{
  ros::init(argc, argv, "ovc4_driver_node");
  // TODO local nodehandle
  ros::NodeHandle nh;
  // Imu publisher
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("imu", 10);
  ros::Publisher image_pub = nh.advertise<sensor_msgs::Image>("image", 3);
  std::unique_ptr<SensorManager> sm = SensorManager::make();
  // Probe imagers then publish IMU data
  ros::Rate loop_rate(30);
  while (ros::ok())
  {
    // Poll at 1kHz
    sensor_msgs::Imu imu_msg;
    sensor_msgs::Image image_msg;
    /*
    auto rx_data = usb.pollData();
    imu_msg.header.stamp = ros::Time::now();
    imu_msg.linear_acceleration.x = rx_data.imu.acc_x;
    imu_msg.linear_acceleration.y = rx_data.imu.acc_y;
    imu_msg.linear_acceleration.z = rx_data.imu.acc_z;
    imu_msg.angular_velocity.x = rx_data.imu.gyro_x;
    imu_msg.angular_velocity.y = rx_data.imu.gyro_y;
    imu_msg.angular_velocity.z = rx_data.imu.gyro_z;
    */
    imu_pub.publish(imu_msg);
    //ROS_INFO("Temperature = %.2f", rx_data.imu.temperature);
    //loop_rate.sleep();
    // Hacky, for testing
    
    //continue;
    auto frame = sm->getFrames();
    image_msg.header.stamp = ros::Time::now();
    image_msg.height = frame.height;
    image_msg.width = frame.width;
    image_msg.step = frame.stride;
    //image_msg.encoding = "rgba8"; // For argus cameras
    image_msg.encoding = "bgr8";
    image_msg.data = std::move(frame.buf);
    image_pub.publish(image_msg);
    
    sm->updateExposure();
  }
}
