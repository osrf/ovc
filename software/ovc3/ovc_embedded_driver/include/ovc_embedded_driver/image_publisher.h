#ifndef IMAGE_PUBLISHER_H
#define IMAGE_PUBLISHER_H

#include <vector>
#include <thread>
#include <ros/ros.h>

#include <sensor_msgs/Image.h>
#include <ovc_embedded_driver/Metadata.h>

#include <ovc_embedded_driver/utilities.h>
#include <ovc_embedded_driver/dma_shapeshifter.h>
#include <ovc_embedded_driver/i2c_driver.h>
#include <ovc_embedded_driver/vdma_driver.h>

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
  I2CDriver i2c;
  std::unique_ptr<VDMADriver> vdma;

  std::vector<uint8_t> image_msg_buffer;

  ros::Publisher image_pub, corner_pub;
  sensor_msgs::Image image_msg;

  std::shared_ptr<AtomicRosTime> time_ptr;

  size_t image_msg_size;
  
  bool run_fast;

  void publishCorners(const ros::Time& frame_time);

public:
  ImagePublisher(ros::NodeHandle nh_p, CameraHWParameters params, std::shared_ptr<AtomicRosTime> t_ptr);

  void publish();
};

} // namespace
#endif
