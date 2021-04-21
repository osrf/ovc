#include <thread>

#include <cv_bridge/cv_bridge.h>
#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/image_encodings.h>

#include <libovc/ovc.hpp>

#include <dynamic_reconfigure/server.h>
#include <ovc_driver/ParamsConfig.h>

void callback(ovc_driver::ParamsConfig &config, uint32_t level) {
  ROS_INFO("Reconfigure Request {exposure: %f}", config.exposure);
}

int main(int argc, char **argv) {
  // Initialize ros systems.
  ros::init(argc, argv, "ovc_driver");
  ros::NodeHandle n;

  // Establish dynamic reconfigure callback.
  dynamic_reconfigure::Server<ovc_driver::ParamsConfig> server;
  dynamic_reconfigure::Server<ovc_driver::ParamsConfig>::CallbackType f;

  f = boost::bind(&callback, _1, _2);
  server.setCallback(f);

  ROS_INFO("Initialize libovc.");
  libovc::OVC ovc;

  // Create the camera publishers.
  std::array<ros::Publisher, libovc::Subscriber::NUM_IMAGERS> cam_pubs;
  for (int i = 0; i < cam_pubs.size(); i++) {
    std::string name = std::string("cam") + std::to_string(i);
    cam_pubs[i] = n.advertise<sensor_msgs::Image>(name, 1000);
  }

  auto begin = ros::Time::now();
  int frame_count = 0;
  ROS_INFO("Begin Loop.");
  while (ros::ok()) {
    ros::spinOnce();

    auto cur_time = ros::Time::now();
    auto diff = (cur_time - begin).toSec();
    if (diff >= 5.0f) {
      ROS_INFO("Averaged %f FPS over the last %f seconds",
               (double)(frame_count) / diff, diff);
      frame_count = 0;
      begin = cur_time;
    }

    auto frames = ovc.getFrames();
    std::array<sensor_msgs::Image, libovc::Subscriber::NUM_IMAGERS> imgs;
    for (int i = 0; i < frames.size(); i++) {
      // Populate header.
      imgs[i].header.frame_id = frames[i].frame_id;
      imgs[i].header.stamp.sec = frames[i].t_sec;
      imgs[i].header.stamp.nsec = frames[i].t_nsec;

      cv_bridge::CvImage cv_image(
          imgs[i].header, sensor_msgs::image_encodings::BGR16, frames[i].image);

      cv_image.toImageMsg(imgs[i]);
    }

    for (int i = 0; i < cam_pubs.size(); i++) {
      cam_pubs[i].publish(imgs[i]);
    }

    // Increment the frame counter.
    frame_count++;
  }

  return 0;
}
