
#include <sensor_msgs/Image.h>
#include <ros/message_traits.h>

#include <ovc_embedded_driver/sensor_constants.h>
#include <ovc_embedded_driver/image_publisher.h>
#include <ovc_embedded_driver/Metadata.h>

using namespace ovc_embedded_driver;

ImagePublisher::ImagePublisher(ros::NodeHandle nh_p, CameraHWParameters params, std::shared_ptr<AtomicRosTime> t_ptr) : nh(nh_p), i2c(params.i2c_num), time_ptr(t_ptr), run_fast(!params.is_rgb)
{
  const std::string img_namespace("ovc/" + params.camera_name + "/");
  // Prepare the shapeshifter
  shape_shifter.morph(
                  ros::message_traits::MD5Sum<sensor_msgs::Image>::value(),
                  ros::message_traits::DataType<sensor_msgs::Image>::value(),
                  ros::message_traits::Definition<sensor_msgs::Image>::value(),
                  "");

  // Advertise topics
  std::string img_topic_name(img_namespace + "image_raw");
  image_pub = shape_shifter.advertise(nh, img_topic_name.c_str(), 1);
  std::string metadata_name(img_namespace + "image_metadata");
  corner_pub = nh.advertise<Metadata>(metadata_name.c_str(), 1);

  // Prepare image message
  image_msg.data.resize(IMAGE_SIZE);
  image_msg.height = RES_Y;
  image_msg.width = RES_X;
  image_msg.header.frame_id = "ovc_image_link";
  if (params.is_rgb)
    image_msg.encoding="bayer_grbg8";
  else
    image_msg.encoding = "mono8";
  image_msg.step = RES_X;

  SerializeToByteArray(image_msg, image_msg_buffer);
  image_msg_size = image_msg_buffer.size();
  // Need to make dynamically because we don't know a-priori the buffer and message size
  vdma = std::make_unique<VDMADriver>(params.vdma_num, params.i2c_num, image_msg_buffer);
}

void ImagePublisher::publish()
{
  while (ros::ok())
  {
    // Wait for interrupt and fill the image message
    unsigned char* image_ptr = vdma->getImage();
    i2c.controlAnalogGain();

    image_msg.header.stamp = time_ptr->get();

    // Serialize the new timestamp, set it and publish
    SerializeToByteArray(image_msg.header, image_msg_buffer);
    vdma->setHeader(image_msg_buffer);
    shape_shifter.assign_data(image_ptr, image_msg_size);
    image_pub.publish(shape_shifter);

    // Publish features after the image so we don't affect the frame latency with feature computation
    if (run_fast)
      publishCorners(image_msg.header.stamp);
  }
}

void ImagePublisher::publishCorners(const ros::Time& frame_time)
{
  if (corner_pub.getNumSubscribers() > 0)
  {
    static Metadata metadata_msg; // To avoid continuous reallocations
    std::vector<uint32_t> corners(vdma->getCorners());
    metadata_msg.corners.reserve(corners.size());
    for (auto& corner_raw : corners)
    {
      ImageCorner corner;
      corner_raw = __builtin_bswap32(corner_raw);
      corner.row = (corner_raw >> 8) & 0x3FF; // 10 bits, 17-8
      corner.col = (corner_raw >> 18) & 0x7FF; // 11 bits, 28-18
      corner.score = corner_raw & 0xFF; // 8 bits, 7-0
      metadata_msg.corners.push_back(corner);
    }
    metadata_msg.header.stamp = frame_time;
    corner_pub.publish(metadata_msg);
    metadata_msg.corners.clear();
  }
}
