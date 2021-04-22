#include <cv_bridge/cv_bridge.h>
#include <dynamic_reconfigure/server.h>
#include <ovc_driver/ParamsConfig.h>
#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/image_encodings.h>

#include <libovc/ovc.hpp>
#include <thread>

class OVCNode
{
private:
  libovc::OVC ovc_;
  std::array<ros::Publisher, libovc::Server::NUM_IMAGERS> cam_pubs_;

public:
  OVCNode(ros::NodeHandle &n)
  {
    // Create the camera publishers.
    for (size_t i = 0; i < cam_pubs_.size(); i++)
    {
      std::string name = std::string("cam") + std::to_string(i);
      cam_pubs_[i] = n.advertise<sensor_msgs::Image>(name, 1000);
    }
  }
  ~OVCNode(){};

  void reconfigure_callback(ovc_driver::ParamsConfig &config, uint32_t level)
  {
    (void)level;
    ROS_INFO("Reconfigure Request {exposure: %f}", config.exposure);
    ovc_.updateConfig(config.exposure);
  }

  void spinOnce()
  {
    auto frames = ovc_.getFrames();
    std::array<sensor_msgs::Image, libovc::Server::NUM_IMAGERS> imgs;
    for (size_t i = 0; i < frames.size(); i++)
    {
      // Populate header.
      imgs[i].header.frame_id = frames[i].frame_id;
      imgs[i].header.stamp.sec = frames[i].t_sec;
      imgs[i].header.stamp.nsec = frames[i].t_nsec;

      cv_bridge::CvImage cv_image(
          imgs[i].header, sensor_msgs::image_encodings::BGR16, frames[i].image);

      cv_image.toImageMsg(imgs[i]);
    }

    for (size_t i = 0; i < cam_pubs_.size(); i++)
    {
      cam_pubs_[i].publish(imgs[i]);
    }
  }
};

int main(int argc, char **argv)
{
  // Initialize ros systems.
  ros::init(argc, argv, "ovc_driver");
  ros::NodeHandle node;

  // Establish dynamic reconfigure callback.
  dynamic_reconfigure::Server<ovc_driver::ParamsConfig> server;
  dynamic_reconfigure::Server<ovc_driver::ParamsConfig>::CallbackType f;

  ROS_INFO("Initialize libovc.");
  OVCNode ovc_node(node);

  f = boost::bind(&OVCNode::reconfigure_callback, &ovc_node, _1, _2);
  server.setCallback(f);

  auto begin = ros::Time::now();
  int frame_count = 0;
  ROS_INFO("Begin Loop.");
  while (ros::ok())
  {
    ros::spinOnce();

    auto cur_time = ros::Time::now();
    auto diff = (cur_time - begin).toSec();
    if (diff >= 5.0f)
    {
      ROS_INFO("Averaged %f FPS over the last %f seconds",
               (double)(frame_count) / diff, diff);
      frame_count = 0;
      begin = cur_time;
    }

    ovc_node.spinOnce();

    // Increment the frame counter.
    frame_count++;
  }

  return 0;
}
