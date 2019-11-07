#include <thread>
#include <memory>
#include <string>
#include <condition_variable>

#include <ros/ros.h>
#include <sensor_msgs/Imu.h>

#include <dynamic_reconfigure/server.h>
#include <ovc_embedded_driver/Ovc3Config.h>
#include <ovc_embedded_driver/sensor_constants.h>
#include <ovc_embedded_driver/utilities.h>
#include <ovc_embedded_driver/image_publisher.h>
#include <ovc_embedded_driver/spi_driver.h>
#include <ovc_embedded_driver/uio_driver.h>

using namespace ovc_embedded_driver;

const int DMA_DEVICES[NUM_CAMERAS] = {6,7,8}; // From hardware
const int I2C_DEVICES[NUM_CAMERAS] = {0,1,2}; // Files in /dev/i2c-, must match DMA

const std::string CAMERA_NAMES[NUM_CAMERAS] = {"right", "left", "rgb"};

// External cameras
const int EXTERNAL_DMA[2*EXTERNAL_BOARDS] = {9,10,11,12};
const int EXTERNAL_I2C[EXTERNAL_BOARDS] = {3,5}; // TODO add second I2C for thermal imager
const int EXTERNAL_THERMAL_I2C[EXTERNAL_BOARDS] = {4, 6};
const std::string EXTERNAL_NAME[2*EXTERNAL_BOARDS] = {"bottom/right", "bottom/left", 
  "top/right", "top/left"};

const int IMU_SYNC_GPIO = 4; // ID of UIO device used with GPIO for syncing
const int FAST_CONFIG_GPIO = 5; // UIO device for corner detection configuration

const int ICM_SPI_DEVICE = 2; // Device number in spidev for ICM20948 imu
const int VECTORNAV_SPI_DEVICE = 1; // SPI Device for Vectornav IMU

const int COLOR_CAMERA_ID = 2; // The only color camera is CAM2
const int VECTORNAV_FSYNC_GPIO = 417;

// Condition Variables
std::condition_variable num_sample_condition_var;
std::mutex num_sample_guard_mutex;
std::unique_lock<std::mutex> num_sample_guard(num_sample_guard_mutex);

// IMU publisher synchronisation vars
int num_sample = -1;
std::atomic<bool> new_imu_sample(false);
ICMDriver spi(ICM_SPI_DEVICE, IMU_SYNC_GPIO);

void update_time_ptr(ros::NodeHandle nh,
                     std::shared_ptr<AtomicRosTime> frame_time_ptr,
                     std::shared_ptr<AtomicRosTime> curr_time_ptr)
{
  while (ros::ok())
  {
    num_sample = spi.getSampleNumber(); // Blocking call
    new_imu_sample = true;
    curr_time_ptr->update_no_notify(ros::Time::now());
    num_sample_condition_var.notify_all();

    // Only update time on the 7th IMU sample
    if (num_sample == 0)
    {
      frame_time_ptr->update(curr_time_ptr->get());
    }
  }
}

void publish_imu(ros::NodeHandle nh,
                 std::shared_ptr<AtomicRosTime> frame_time_ptr,
                 std::shared_ptr<AtomicRosTime> curr_time_ptr)
{
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("imu", 10);

  sensor_msgs::Imu imu_msg;
  imu_msg.header.frame_id = "ovc_imu_link";

  while (ros::ok())
  {
    // If a new IMU sample has not been detected yet, wait
    while (!new_imu_sample.load())
    {
      num_sample_condition_var.wait(num_sample_guard);
    }
    imu_msg.header.stamp = curr_time_ptr->get();
    new_imu_sample = false;

    IMUReading imu = spi.readSensors();

    imu_msg.angular_velocity.x = imu.g_x;
    imu_msg.angular_velocity.y = imu.g_y;
    imu_msg.angular_velocity.z = imu.g_z;
    imu_msg.linear_acceleration.x = imu.a_x;
    imu_msg.linear_acceleration.y = imu.a_y;
    imu_msg.linear_acceleration.z = imu.a_z;

    // Sample synchronised with frame trigger
    imu_pub.publish(imu_msg);
  }
}

void publish_vnav(ros::NodeHandle nh, std::shared_ptr<AtomicRosTime> time_ptr)
{
  VNAVDriver spi(VECTORNAV_SPI_DEVICE, VECTORNAV_FSYNC_GPIO);
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("vectornav", 10);
  sensor_msgs::Imu imu_msg;
  imu_msg.header.frame_id = "ovc_vnav_link";
  while (ros::ok())
  {
    // Vectornav is not synchronised to anything, just use system time to stamp it
    IMUReading imu;
    spi.waitNewSample();
    imu_msg.header.stamp = ros::Time::now();
    // Skip message filling if communication failed
    if (spi.readSensors(imu))
      continue;
    imu_msg.orientation.x = imu.q_x;
    imu_msg.orientation.y = imu.q_y;
    imu_msg.orientation.z = imu.q_z;
    imu_msg.orientation.w = imu.q_w;
    imu_msg.angular_velocity.x = imu.g_x;
    imu_msg.angular_velocity.y = imu.g_y;
    imu_msg.angular_velocity.z = imu.g_z;
    imu_msg.linear_acceleration.x = imu.a_x;
    imu_msg.linear_acceleration.y = imu.a_y;
    imu_msg.linear_acceleration.z = imu.a_z;
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

void reconfigure_callback(Ovc3Config &conf, uint32_t level)
{
  // TODO add more reconfigurability
  configureFAST(conf.fast_enable, conf.fast_threshold);
}

int main(int argc, char **argv)
{
  // Init ROS
  ros::init(argc, argv, "ovc_embedded_driver_node");
  ros::NodeHandle nh("/ovc");

  std::shared_ptr<AtomicRosTime> curr_time_ptr = std::make_shared<AtomicRosTime>();
  std::shared_ptr<AtomicRosTime> frame_time_ptr = std::make_shared<AtomicRosTime>();
  dynamic_reconfigure::Server<Ovc3Config> server;
  dynamic_reconfigure::Server<Ovc3Config>::CallbackType c;
  c = boost::bind(&reconfigure_callback, _1, _2);
  server.setCallback(c);
  ros::AsyncSpinner spinner(1);

  // Init threads
  std::vector<std::unique_ptr<std::thread>> threads; // one each for IMU and frame_time_ptr update threads
  std::unique_ptr<ImagePublisher> image_publisher[NUM_CAMERAS];
  std::unique_ptr<ExternalCameraPublisher> external_publishers[EXTERNAL_BOARDS];

  // IMU thread
  threads.push_back(std::make_unique<std::thread>(publish_imu, nh, frame_time_ptr, curr_time_ptr));

  // Time object update thread
  threads.push_back(std::make_unique<std::thread>(update_time_ptr, nh, frame_time_ptr, curr_time_ptr));

  threads.push_back(std::make_unique<std::thread>(publish_vnav, nh, curr_time_ptr));
  
  // Image Publisher threads
  for (size_t i=0; i<NUM_CAMERAS; ++i)
  {
    CameraHWParameters params(DMA_DEVICES[i], I2C_DEVICES[i], 0, CAMERA_NAMES[i], i == COLOR_CAMERA_ID);
    image_publisher[i] = std::make_unique<ImagePublisher>(nh, params, frame_time_ptr);
    threads.push_back(std::make_unique<std::thread>(&ImagePublisher::publish_loop, image_publisher[i].get()));
  }
  // External camera boards
  // For now only add one external pair
  for (size_t i=0; i<EXTERNAL_BOARDS; ++i)
  {
    CameraHWParameters right_params(EXTERNAL_DMA[2*i], EXTERNAL_I2C[i], 1, EXTERNAL_NAME[2*i], true);
    CameraHWParameters left_params(EXTERNAL_DMA[2*i+1], EXTERNAL_I2C[i], 0, EXTERNAL_NAME[2*i+1], true);
    external_publishers[i] = std::make_unique<ExternalCameraPublisher>(nh, right_params, left_params, frame_time_ptr);
    threads.push_back(std::make_unique<std::thread>(&ExternalCameraPublisher::publish_right, external_publishers[i].get()));
    threads.push_back(std::make_unique<std::thread>(&ExternalCameraPublisher::publish_left, external_publishers[i].get()));
  }

  // INIT
  curr_time_ptr->update_no_notify(ros::Time::now());
  frame_time_ptr->update(curr_time_ptr->get());

  spinner.start();

  // TODO refactor thread vector
  // Wait for each thread to end
  threads[0]->join();
  return 0;
}
