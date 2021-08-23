#include <cv_bridge/cv_bridge.h>
#include <dynamic_reconfigure/server.h>
#include <jsoncpp/json/json.h>
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
  std::unordered_map<uint8_t, ros::Publisher> cam_pubs_;

  void new_camera(uint8_t camera_id)
  {
    if (node_handle_ != nullptr)
    {
      std::string name = std::string("ovc_cam") + std::to_string(camera_id);
      cam_pubs_[camera_id] =
          node_handle_->advertise<sensor_msgs::Image>(name, 1000);
    }
  }
  ros::NodeHandle *node_handle_ = nullptr;

public:
  OVCNode(ros::NodeHandle &n) { node_handle_ = &n; }
  ~OVCNode(){};

  void reconfigure_callback(ovc_driver::ParamsConfig &config, uint32_t level)
  {
    (void)level;

    Json::Value cam_config;
    cam_config["fps"] = (float)config.frame_rate;
    Json::Value cam;
    cam["id"] = config.id;
    cam["exposure"] = (float)config.exposure;
    cam_config["cameras"].append(cam);

    ROS_INFO(
        "Reconfigure Request "
        "{exposure: %f}"
        "{frame_rate: %f}",
        config.exposure,
        config.frame_rate);
    ovc_.updateConfig(cam_config);
  }

  void spinOnce()
  {
    auto frames = ovc_.getFrames();
    sensor_msgs::Image img;
    for (auto &[id, frame] : frames)
    {
      if (cam_pubs_.find(id) == cam_pubs_.end())
      {
        new_camera(id);
      }
      // Populate header.
      img.header.frame_id = frame.frame_id;
      img.header.stamp.sec = frame.t_sec;
      img.header.stamp.nsec = frame.t_nsec;

      cv_bridge::CvImage cv_image(
          img.header, sensor_msgs::image_encodings::BGR16, frame.image);

      cv_image.toImageMsg(img);
      cam_pubs_[id].publish(img);
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
               (double)(frame_count) / diff,
               diff);
      frame_count = 0;
      begin = cur_time;
    }

    ovc_node.spinOnce();

    // Increment the frame counter.
    frame_count++;
  }

  return 0;
}
