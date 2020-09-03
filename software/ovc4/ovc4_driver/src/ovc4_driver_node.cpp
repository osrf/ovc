#include <thread>
#include <memory>
#include <ros/ros.h>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <ovc4_driver/sensor_manager.hpp>

#include <sensor_msgs/Imu.h>
#include <sensor_msgs/Image.h>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>

// TODO change names to be more explicative depending on setup
static constexpr char* CAMERA_NAMES[NUM_CAMERAS] = {"image_0", "image_1", "image_2", "image_3", "image_4", "image_5"};

void publish(int cam_id, image_transport::ImageTransport it, std::shared_ptr<SensorManager> sm)
{
  image_transport::Publisher image_pub = it.advertise(CAMERA_NAMES[cam_id], 2);
  while (ros::ok())
  {
    auto frame = sm->getFrame(cam_id);
    image_pub.publish(frame->toImageMsg());

    // TODO use exposure from cam0 for all sensors
    if (cam_id == 0)
      sm->updateExposure();
  }
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "ovc4_driver_node");
  // TODO local nodehandle
  ros::NodeHandle nh;
  // Imu publisher
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("imu", 10);
  image_transport::ImageTransport it(nh);
  std::shared_ptr<SensorManager> sm = SensorManager::make();
  std::vector<std::unique_ptr<std::thread>> threads;
  for (const auto& cam_id : sm->getProbedCameraIds())
  {
    std::cout << "Creating thread for camera " << cam_id << std::endl;
    threads.push_back(std::make_unique<std::thread>(publish, cam_id, it, sm));
  }
  threads[0]->join();
  while (ros::ok())
  {
    // Poll at 1kHz
    sensor_msgs::Imu imu_msg;
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
    //imu_pub.publish(imu_msg);
    //ROS_INFO("Temperature = %.2f", rx_data.imu.temperature);
    //loop_rate.sleep();
    // Hacky, for testing
    
    //continue;
    //frames = sm->getFrames();
    //image_msg.header.stamp = ros::Time::now();
    //image_msg.height = frame.height;
    //image_msg.width = frame.width;
    //image_msg.step = frame.stride;
    //image_msg.encoding = "rgba8"; // For argus cameras
    //image_msg.encoding = "bgr8";
    //image_msg.data = std::move(frame.buf);
    //image_pub.publish(image_msg);
    //image_pub.publish(frames[0]->toImageMsg());
    //image_pub2.publish(frames[1]->toImageMsg());
    
    //sm->updateExposure();
  }
}
