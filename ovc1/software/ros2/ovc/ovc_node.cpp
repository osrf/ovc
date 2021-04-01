// Copyright 2018 Open Source Robotics Foundation, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "rclcpp/rclcpp.hpp"
#include "sensor_msgs/msg/image.hpp"
#include "ovc.h"
#include "rcutils/time.h"
#include "sensor_msgs/msg/image.hpp"

using namespace std::chrono_literals;  // for time literal abbreviations

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);
  auto node = rclcpp::Node::make_shared("ovc");

  OVC ovc;
  if (!ovc.init()) {
    printf("ovc init failed");
    return 1;
  }

  rcutils_time_point_value_t t_prev = 0, t_now = 0;
  rcutils_system_time_now(&t_prev);

  //cv::Mat img_rgb(IMG_HEIGHT, IMG_WIDTH, CV_8UC3);
  auto image_msg = std::make_shared<sensor_msgs::msg::Image>();
  image_msg->width = 1280;
  image_msg->height = 1024*2;
  image_msg->encoding = "mono8";
  image_msg->step = 1280;
  image_msg->data.resize(image_msg->step * image_msg->height);
  auto qos_profile = rmw_qos_profile_sensor_data;
  qos_profile.depth = 2;
  qos_profile.reliability = RMW_QOS_POLICY_RELIABILITY_RELIABLE;
  //qos_profile.reliability = RMW_QOS_POLICY_RELIABILITY_BEST_EFFORT;
  auto image_pub_ = node->create_publisher<sensor_msgs::msg::Image>("image",
      qos_profile);

  while (rclcpp::ok()) {
    rclcpp::spin_some(node);
    // grab image
    uint8_t *img_data = NULL;
    if (!ovc.wait_for_image(&img_data)) {
      printf("OVC::wait_for_image() failed");
      break;
    }
    uint32_t *sig = (uint32_t *)(&img_data[1280*1024*2]);
    bool sig_ok = ovc.validate_signature(img_data, 1280*1024, sig);
    memcpy(&image_msg->data[0], img_data, image_msg->step * image_msg->height);


    /*
    memcpy(&image_msg->data[0], img_rgb.data,
      image_msg->step * image_msg->height);
    */

    image_pub_->publish(image_msg);
    rcutils_system_time_now(&t_now);
    double dt = 1.0e-9 * (double)(t_now - t_prev);
    printf("dt = %.6f  FPS = %.1f\n", dt, 1.0 / dt);
    t_prev = t_now;
  }

  return 0;
}
