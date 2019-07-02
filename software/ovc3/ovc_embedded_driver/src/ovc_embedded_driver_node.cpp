#include <vector>
#include <thread>
#include <memory>
#include <mutex>
#include <string>

#include <ros/ros.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/Imu.h>
#include <ros/message_traits.h>

#include <ovc_embedded_driver/Metadata.h>
#include <ovc_embedded_driver/ConfigureFAST.h>
#include <ovc_embedded_driver/sensor_constants.h>
#include <ovc_embedded_driver/dma_shapeshifter.h>
#include <ovc_embedded_driver/vdma_driver.h>
#include <ovc_embedded_driver/i2c_driver.h>
#include <ovc_embedded_driver/spi_driver.h>
#include <ovc_embedded_driver/uio_driver.h>

#define NUM_CAMERAS 3

using namespace ovc_embedded_driver;

const int DMA_DEVICES[NUM_CAMERAS] = {6,7,8}; // From hardware
const int I2C_DEVICES[NUM_CAMERAS] = {0,1,2}; // Files in /dev/i2c-, must match DMA

const std::string CAMERA_NAMES[NUM_CAMERAS] = {"right", "left", "rgb"};

const int IMU_SYNC_GPIO = 4; // ID of UIO device used with GPIO for syncing
const int FAST_CONFIG_GPIO = 5; // UIO device for corner detection configuration

const int COLOR_CAMERA_ID = 2; // The only color camera is CAM2

ros::Time frame_time;
std::mutex ft_mutex; // Make sure we don't corrupt the frame_time

template <typename T>
void SerializeToByteArray(const T& msg, std::vector<uint8_t>& destination_buffer)
{ 
  const uint32_t length = ros::serialization::serializationLength(msg);
  destination_buffer.resize( length );
  //copy into your own buffer 
  ros::serialization::OStream stream(destination_buffer.data(), length);
  ros::serialization::serialize(stream, msg);
}

void publish_image(int device_num)
{
  ros::NodeHandle nh;

  DMAShapeShifter shape_shifter;
  shape_shifter.morph(
                  ros::message_traits::MD5Sum<sensor_msgs::Image>::value(),
                  ros::message_traits::DataType<sensor_msgs::Image>::value(),
                  ros::message_traits::Definition<sensor_msgs::Image>::value(),
                  "");
  
  std::vector<uint8_t> buffer;

  // Init camera
  I2CDriver i2c(I2C_DEVICES[device_num]);

  std::string topic_name("ovc/" + CAMERA_NAMES[device_num] + "/image_raw");
  ros::Publisher pub = shape_shifter.advertise(nh, topic_name.c_str(), 1);
  std::string metadata_name("ovc/" + CAMERA_NAMES[device_num] + "/image_metadata");
  ros::Publisher corner_pub = nh.advertise<Metadata>(metadata_name.c_str(), 1);
  sensor_msgs::Image image_msg;
  Metadata metadata_msg;
  image_msg.data.resize(IMAGE_SIZE);
  image_msg.height = RES_Y;
  image_msg.width = RES_X;
  if (device_num == COLOR_CAMERA_ID)
    image_msg.encoding="bayer_grbg8";
  else
    image_msg.encoding = "mono8";
  image_msg.step = RES_X;

  // VDMA declared here so we can prefill the header, vector type is uint8_t
  size_t image_size = image_msg.data.size();
  SerializeToByteArray(image_msg, buffer);
  size_t msg_size = buffer.size();
  VDMADriver vdma(DMA_DEVICES[device_num], device_num, buffer, image_size);

  std::unique_lock<std::mutex> frame_time_mutex(ft_mutex, std::defer_lock);
  while (ros::ok())
  {
    // Fill the message
    unsigned char* image_ptr = vdma.getImage();
    if (device_num != COLOR_CAMERA_ID)
    {
      std::vector<uint32_t> corners(vdma.getCorners());
      metadata_msg.corner_array.corners.reserve(corners.size());
      for (auto& corner_raw : corners)
      {
        ImageCorner corner;
        corner_raw = __builtin_bswap32(corner_raw);
        corner.row = (corner_raw >> 8) & 0x3FF; // 10 bits, 17-8
        corner.col = (corner_raw >> 18) & 0x7FF; // 11 bits, 28-18
        corner.score = corner_raw & 0xFF; // 8 bits, 7-0
        
        metadata_msg.corner_array.corners.push_back(corner);
      }
    }

    i2c.controlAnalogGain();

    frame_time_mutex.lock();
    image_msg.header.stamp = frame_time;
    metadata_msg.header.stamp = frame_time;
    frame_time_mutex.unlock();

    SerializeToByteArray(image_msg.header, buffer);
    vdma.setHeader(buffer);
    shape_shifter.assign_data(image_ptr, msg_size);
    pub.publish(shape_shifter);
    corner_pub.publish(metadata_msg);
    metadata_msg.corner_array.corners.clear();
  }
}

void publish_imu()
{
  SPIDriver spi(IMU_SYNC_GPIO);
  ros::NodeHandle nh;
  std::unique_lock<std::mutex> frame_time_mutex(ft_mutex, std::defer_lock);
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("/ovc/imu", 10);
  sensor_msgs::Imu imu_msg;
  while (ros::ok())
  {
    IMUReading imu = spi.readSensors();
    // TODO check if delay incurred by SPI transaction is indeed negligible
    ros::Time cur_time = ros::Time::now();
    imu_msg.header.stamp = cur_time;
    imu_msg.angular_velocity.x = imu.g_x;
    imu_msg.angular_velocity.y = imu.g_y;
    imu_msg.angular_velocity.z = imu.g_z;
    imu_msg.linear_acceleration.x = imu.a_x;
    imu_msg.linear_acceleration.y = imu.a_y;
    imu_msg.linear_acceleration.z = imu.a_z;
    if (imu.num_sample == 0)
    {
      // Sample synchronised with frame trigger
      frame_time_mutex.lock();
      frame_time = cur_time;
      frame_time_mutex.unlock();
    }
    imu_pub.publish(imu_msg);
  }
}

void configureFAST(bool enable, int thresh)
{
  static UIODriver uio(FAST_CONFIG_GPIO, 0x1000); 
  uint32_t write_val = thresh & 0xFF;
  write_val |= enable << 8;
  uio.writeRegister(0, write_val);
}

bool configureFAST_cb(ConfigureFAST::Request &req, ConfigureFAST::Response &res)
{
  configureFAST(req.enable, req.threshold);
  return true;
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "ovc_embedded_driver_node");
  ros::NodeHandle nh;
  configureFAST(1, 25);
  ros::ServiceServer fast_serv = nh.advertiseService("/ovc/configure_fast", configureFAST_cb);
  ros::AsyncSpinner spinner(1);
  std::unique_ptr<std::thread> threads[NUM_CAMERAS + 1]; // one for IMU
  for (int i=0; i<NUM_CAMERAS; ++i)
    threads[i] = std::make_unique<std::thread>(publish_image,i);
  threads[NUM_CAMERAS] = std::make_unique<std::thread>(publish_imu);
  spinner.start();

  threads[NUM_CAMERAS]->join();
}
