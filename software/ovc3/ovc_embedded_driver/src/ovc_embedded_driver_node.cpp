#include <thread>
#include <memory>
#include <string>
#include <condition_variable>

#include <ros/ros.h>
#include <sensor_msgs/Imu.h>

#include <ovc_embedded_driver/ConfigureFAST.h>
#include <ovc_embedded_driver/sensor_constants.h>
#include <ovc_embedded_driver/utilities.h>
#include <ovc_embedded_driver/image_publisher.h>
#include <ovc_embedded_driver/spi_driver.h>
#include <ovc_embedded_driver/uio_driver.h>

using namespace ovc_embedded_driver;

const int DMA_DEVICES[NUM_CAMERAS] = {6,7,8}; // From hardware
const int I2C_DEVICES[NUM_CAMERAS] = {0,1,2}; // Files in /dev/i2c-, must match DMA

const std::string CAMERA_NAMES[NUM_CAMERAS] = {"right", "left", "rgb"};

const int IMU_SYNC_GPIO = 4; // ID of UIO device used with GPIO for syncing
const int FAST_CONFIG_GPIO = 5; // UIO device for corner detection configuration

const int COLOR_CAMERA_ID = 2; // The only color camera is CAM2

SPIDriver spi(IMU_SYNC_GPIO);

// Condition Variables
std::condition_variable num_sample_condition_var;
std::mutex num_sample_guard_mutex;
std::unique_lock<std::mutex> num_sample_guard(num_sample_guard_mutex);

std::condition_variable time_condition_var;
std::mutex time_guard_mutex;
std::unique_lock<std::mutex> time_guard(time_guard_mutex);

// IMU publisher synchronisation vars
int num_sample = -1;
std::atomic<bool> new_imu_sample(false);

void update_time_ptr(ros::NodeHandle nh,
                     std::shared_ptr<AtomicRosTime> frame_time_ptr,
                     std::shared_ptr<AtomicRosTime> curr_time_ptr)
{
  while (ros::ok())
  {
    num_sample = spi.getSampleNumber(); // Blocking call
    new_imu_sample = true;
    num_sample_condition_var.notify_all();

    curr_time_ptr->update(ros::Time::now());

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
  ros::Publisher imu_pub = nh.advertise<sensor_msgs::Imu>("/ovc/imu", 10);
  sensor_msgs::Imu imu_msg;

  while (ros::ok())
  {
    // If a new IMU sample has not been detected yet, wait
    while (!new_imu_sample.load())
    {
      num_sample_condition_var.wait(num_sample_guard);
    }
    new_imu_sample = false;

    IMUReading imu = spi.readSensors();

    // TODO check if delay incurred by SPI transaction is indeed negligible

    imu_msg.header.stamp = curr_time_ptr->get();
    imu_msg.header.frame_id = "ovc_imu_link";

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
  // Init ROS
  ros::init(argc, argv, "ovc_embedded_driver_node");
  ros::NodeHandle nh;

  std::shared_ptr<AtomicRosTime> curr_time_ptr = std::make_shared<AtomicRosTime>();
  std::shared_ptr<AtomicRosTime> frame_time_ptr = std::make_shared<AtomicRosTime>();
  ros::ServiceServer fast_serv = nh.advertiseService("/ovc/configure_fast", configureFAST_cb);
  ros::AsyncSpinner spinner(1);

  configureFAST(1, 60);

  // Init threads
  std::unique_ptr<std::thread> threads[NUM_CAMERAS + 2]; // one each for IMU and frame_time_ptr update threads
  std::unique_ptr<ImagePublisher> image_publisher[NUM_CAMERAS];

  // IMU thread
  threads[NUM_CAMERAS] = std::make_unique<std::thread>(publish_imu, nh, frame_time_ptr, curr_time_ptr);

  // Time object update thread
  threads[NUM_CAMERAS + 1] = std::make_unique<std::thread>(update_time_ptr, nh, frame_time_ptr, curr_time_ptr);

  // Image Publisher threads
  for (size_t i=0; i<NUM_CAMERAS; ++i)
  {
    CameraHWParameters params(DMA_DEVICES[i], I2C_DEVICES[i], CAMERA_NAMES[i], i == COLOR_CAMERA_ID);
    image_publisher[i] = std::make_unique<ImagePublisher>(nh, params, frame_time_ptr);
    threads[i] = std::make_unique<std::thread>(&ImagePublisher::publish, image_publisher[i].get());
  }

  // INIT
  curr_time_ptr->update(ros::Time::now());
  frame_time_ptr->update(curr_time_ptr->get());

  spinner.start();

  // Wait for each thread to end
  threads[NUM_CAMERAS]->join();
}
