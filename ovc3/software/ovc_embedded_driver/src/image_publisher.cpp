#include <condition_variable>

#include <sensor_msgs/Image.h>
#include <ros/message_traits.h>

#include <ovc_embedded_driver/sensor_constants.h>
#include <ovc_embedded_driver/image_publisher.h>
#include <ovc_embedded_driver/Metadata.h>

using namespace ovc_embedded_driver;

ImagePublisher::ImagePublisher(ros::NodeHandle nh_p,
                               CameraHWParameters params,
                               std::shared_ptr<AtomicRosTime> t_ptr)
  : nh(nh_p, params.camera_name)
  , i2c(params.i2c_dev, params.i2c_lsb)
  , time_ptr(t_ptr)
  , cam_info_manager(nh, params.camera_name)
  , run_fast(!params.is_rgb)
{
  // Initialise condition variable conditions
  last_time_write_count = time_ptr->time_write_count.load();

  // Prepare the shapeshifter
  shape_shifter.morph(
                  ros::message_traits::MD5Sum<sensor_msgs::Image>::value(),
                  ros::message_traits::DataType<sensor_msgs::Image>::value(),
                  ros::message_traits::Definition<sensor_msgs::Image>::value(),
                  "");

  // Load calibration parameters
  std::string cam_info_url("package://ovc_embedded_driver/calibration/" +
      params.camera_name + ".yaml");
  if (cam_info_manager.validateURL(cam_info_url))
    cam_info_manager.loadCameraInfo(cam_info_url);

  // Advertise topics
  image_pub = shape_shifter.advertise(nh, "image_raw", 1);
  corner_pub = nh.advertise<Metadata>("image_metadata", 1);
  cam_info_pub = nh.advertise<sensor_msgs::CameraInfo>("camera_info", 1);

  // Prepare image message
  image_msg.data.resize(IMAGE_SIZE);
  image_msg.height = RES_Y;
  image_msg.width = RES_X;
  image_msg.header.frame_id = "ovc_camera_link_optical";
  if (params.is_rgb)
    image_msg.encoding="bayer_grbg8";
  else
    image_msg.encoding = "mono8";
  image_msg.step = RES_X;

  SerializeToByteArray(image_msg, image_msg_buffer);
  image_msg_size = image_msg_buffer.size();
  // Need to make dynamically because we don't know a-priori the buffer and message size
  vdma = std::make_unique<VDMADriver>(params.vdma_dev, image_msg_buffer);
}

void ImagePublisher::publish_loop()
{
  while(ros::ok())
  {
    publish();
  }
}

void ImagePublisher::publish()
{
  // Wait for interrupt and fill the image message
  unsigned char* image_ptr = vdma->getImage();

  // Wait for time to update before reading it
  image_msg.header.stamp = time_ptr->get_wait(last_time_write_count);
  last_time_write_count = time_ptr->time_write_count.load();

  // Serialize the new timestamp, set it and publish
  SerializeToByteArray(image_msg.header, image_msg_buffer);
  vdma->setHeader(image_msg_buffer);
  shape_shifter.assign_data(image_ptr, image_msg_size);
  image_pub.publish(shape_shifter);
  // Published synchronised camera_info message
  cam_info_msg = cam_info_manager.getCameraInfo();
  cam_info_msg.header.frame_id = "ovc_camera_link_optical";
  cam_info_msg.header.stamp = image_msg.header.stamp;
  cam_info_pub.publish(cam_info_msg);

  // Publish features after the image so we don't affect the frame latency with feature computation
  if (run_fast)
    publishCorners(image_msg.header.stamp);

  // Send i2c transaction to optimise camera exposure
  i2c.controlAnalogGain();
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

ExternalCameraPublisher::ExternalCameraPublisher(ros::NodeHandle nh,
                        CameraHWParameters right_params,
                        CameraHWParameters left_params,
                        std::shared_ptr<AtomicRosTime> t_ptr) :
  right_pub(nh, right_params, t_ptr),
  left_pub(nh, left_params, t_ptr)
{}

void ExternalCameraPublisher::publish_right()
{
  while(ros::ok())
  {
    right_pub.publish();
  }
}

void ExternalCameraPublisher::publish_left()
{
  while(ros::ok())
  {
    left_pub.publish();
  }
}
