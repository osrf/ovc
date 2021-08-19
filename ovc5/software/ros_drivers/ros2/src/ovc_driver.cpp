#include <cv_bridge/cv_bridge.h>

#include <libovc/ovc.hpp>
#include <memory>
#include <rclcpp/rclcpp.hpp>
#include <sensor_msgs/msg/image.hpp>
#include <thread>

using namespace std::chrono_literals;

class OVCPublisher : public rclcpp::Node
{
public:
  OVCPublisher() : Node("ovc_publisher")
  {
    // Set all default values.
    config_.exposure = 10;    // ms
    config_.frame_rate = 30;  // Hz
    frame_count = 0;

    RCLCPP_INFO(this->get_logger(), "Initialize libovc.");
    ovc_ = std::make_shared<libovc::OVC>();

    this->declare_parameter<float>("exposure", config_.exposure);
    this->declare_parameter<float>("frame_rate", config_.frame_rate);
    // Create the camera publishers.
    for (size_t i = 0; i < publishers_.size(); i++)
    {
      std::string name = std::string("cam") + std::to_string(i);
      publishers_[i] =
          this->create_publisher<sensor_msgs::msg::Image>(name, 1000);
    }
    timer_ = this->create_wall_timer(
        10ms, std::bind(&OVCPublisher::timer_callback, this));
    begin_ = this->now();
  }

private:
  void timer_callback()
  {
    auto cur_time = this->now();
    auto diff = (cur_time - begin_).seconds();
    if (diff >= 5.0f)
    {
      RCLCPP_INFO(this->get_logger(),
                  "Averaged %f FPS over the last %f seconds",
                  (double)(frame_count) / diff,
                  diff);
      frame_count = 0;
      begin_ = cur_time;
    }

    auto frames = ovc_->getFrames();
    std::array<sensor_msgs::msg::Image, libovc::Server::NUM_IMAGERS> imgs;
    for (size_t i = 0; i < frames.size(); i++)
    {
      // Populate header.
      imgs[i].header.frame_id = frames[i].frame_id;
      imgs[i].header.stamp.sec = frames[i].t_sec;

      cv_bridge::CvImage cv_image(
          imgs[i].header, sensor_msgs::image_encodings::BGR16, frames[i].image);

      cv_image.toImageMsg(imgs[i]);
    }

    for (size_t i = 0; i < publishers_.size(); i++)
    {
      publishers_[i]->publish(imgs[i]);
    }

    updateParams();

    // Increment the frame counter.
    frame_count++;
  }

  void updateParams()
  {
    config_t new_config;
    this->get_parameter("exposure", new_config.exposure);
    this->get_parameter("frame_rate", new_config.frame_rate);
    if (new_config != config_)
    {
      RCLCPP_INFO(this->get_logger(),
                  "Recevied param update "
                  "{exposure: %f}"
                  "{frame_rate: %f}",
                  new_config.exposure,
                  new_config.frame_rate);
      config_ = new_config;
      ovc_->updateConfig(config_.exposure);
    }
  }

  std::shared_ptr<libovc::OVC> ovc_;
  rclcpp::TimerBase::SharedPtr timer_;
  std::array<rclcpp::Publisher<sensor_msgs::msg::Image>::SharedPtr,
             libovc::Server::NUM_IMAGERS>
      publishers_;
  int frame_count;
  rclcpp::Time begin_;

  // Camera Params.
  config_t config_;
};

int main(int argc, char **argv)
{
  // Initialize ros systems.
  rclcpp::init(argc, argv);
  auto node = rclcpp::Node::make_shared("ovc_node");
  rclcpp::spin(std::make_shared<OVCPublisher>());
  rclcpp::shutdown();
  return 0;
}
