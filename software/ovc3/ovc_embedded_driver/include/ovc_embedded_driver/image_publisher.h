#ifndef IMAGE_PUBLISHER_H
#define IMAGE_PUBLISHER_H

#include <vector>
#include <thread>
#include <ros/ros.h>

#include <sensor_msgs/Image.h>
#include <sensor_msgs/CameraInfo.h>
#include <camera_info_manager/camera_info_manager.h>
#include <ovc_embedded_driver/Metadata.h>

#include <ovc_embedded_driver/utilities.h>
#include <ovc_embedded_driver/dma_shapeshifter.h>
#include <ovc_embedded_driver/i2c_driver.h>
#include <ovc_embedded_driver/vdma_driver.h>

using camera_info_manager::CameraInfoManager;

namespace ovc_embedded_driver {

template <typename T>
void SerializeToByteArray(const T& msg, std::vector<uint8_t>& destination_buffer)
{
  const uint32_t length = ros::serialization::serializationLength(msg);
  destination_buffer.resize( length );
  //copy into your own buffer
  ros::serialization::OStream stream(destination_buffer.data(), length);
  ros::serialization::serialize(stream, msg);
}

class ImagePublisher
{
  ros::NodeHandle nh;

  DMAShapeShifter shape_shifter;
  ImagerI2C i2c;
  std::unique_ptr<VDMADriver> vdma;

  std::shared_ptr<AtomicRosTime> time_ptr;

  std::vector<uint8_t> image_msg_buffer;

  CameraInfoManager cam_info_manager;
  ros::Publisher image_pub, corner_pub, cam_info_pub;
  sensor_msgs::Image image_msg;
  sensor_msgs::CameraInfo cam_info_msg;

  size_t image_msg_size;
  bool run_fast;
  void publishCorners(const ros::Time& frame_time);

  uint8_t last_time_write_count;

public:
  ImagePublisher(ros::NodeHandle nh_p,
                 CameraHWParameters params,
                 std::shared_ptr<AtomicRosTime> t_ptr);

  void publish();
  void publish_loop();
};

// Class for external camera boards, in which the cameras share an i2c device
class ExternalCameraPublisher
{
  ImagePublisher right_pub, left_pub;

public:
  ExternalCameraPublisher(ros::NodeHandle nh,
                          CameraHWParameters right_params,
                          CameraHWParameters left_params,
                          std::shared_ptr<AtomicRosTime> t_ptr);

  // TODO look into multithreaded publish, for now single
  void publish_loop();
};
} // namespace
#endif
