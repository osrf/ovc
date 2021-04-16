#include <thread>

#include <cv_bridge/cv_bridge.h>
#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/image_encodings.h>

#include "subscriber.hpp"

static cv::Mat unpackTo16(const cv::Mat &frame) {
  cv::Mat ret(frame.rows, frame.cols, CV_16UC1);
  uint8_t *in8 = frame.data;
  uint16_t *out16 = (uint16_t *)ret.data;

  size_t n = frame.cols * frame.rows;
  unsigned full, half;

  for (n/=2; n--; )
  {
    full = *in8++;
    half = *in8++;
    *out16++ = ((((uint16_t)half & 0xF) << 8) | full) << 4;

    full = *in8++;
    *out16++ = ((half >> 4) | ((uint16_t)full << 4)) << 4;
  }
  
  return ret;
}

int main(int argc, char **argv) {
  // Initialize ros systems.
  ros::init(argc, argv, "ovc");
  ros::NodeHandle n;

  // Start the subscriber thread (collects images).
  Subscriber sub;
  std::thread thread(&Subscriber::receiveThread, &sub);

  // Create the camera publishers.
  std::array<ros::Publisher, sub.NUM_IMAGERS> cam_pubs;
  for (int i = 0; i < sub.NUM_IMAGERS; i++) {
    std::string name = std::string("cam") + std::to_string(i);
    cam_pubs[i] = n.advertise<sensor_msgs::Image>(name, 1000);
  }

  auto begin = ros::Time::now();
  int frame_count = 0;
  while (ros::ok()) {

    auto cur_time = ros::Time::now();
    auto diff = (cur_time - begin).toSec();
    if (diff >= 5.0f) {
      ROS_INFO("Averaged %f FPS over the last %f seconds",
               (double)(frame_count) / diff, diff);
      frame_count = 0;
      begin = cur_time;
    }

    auto frames = sub.getFrames();
    std::array<sensor_msgs::Image, sub.NUM_IMAGERS> imgs;
    for (int i = 0; i < sub.NUM_IMAGERS; i++) {
      cv::Mat frame;
      cv::Mat shifted = unpackTo16(frames[i].image);
      cv::cvtColor(shifted, frame, cv::COLOR_BayerBG2RGB);

      // Populate header.
      imgs[i].header.frame_id = frames[i].frame_id;
      imgs[i].header.stamp.sec = frames[i].t_sec;
      imgs[i].header.stamp.nsec = frames[i].t_nsec;

      cv_bridge::CvImage cv_image(imgs[i].header,
                                  sensor_msgs::image_encodings::RGB16, frame);

      cv_image.toImageMsg(imgs[i]);
    }

    for (int i = 0; i < sub.NUM_IMAGERS; i++) {
      cam_pubs[i].publish(imgs[i]);
    }

    // Increment the frame counter.
    frame_count++;
  }

  thread.join();
  return 0;
}
