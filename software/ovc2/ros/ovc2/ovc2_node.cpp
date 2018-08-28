#include <cv_bridge/cv_bridge.h>
#include <image_transport/image_transport.h>
#include <ros/ros.h>
#include <thread>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/Imu.h>
#include "ovc2.h"
#include "ovc2/Metadata.h"
#include "ovc2/ImageCornerArray.h"
#include "ovc2/ImageCorner.h"

using ovc2::OVC2;

void cam_thread_fn(OVC2 *ovc2, ros::NodeHandle *nh)
{
  image_transport::ImageTransport image_t(*nh);
  image_transport::Publisher image_pub = image_t.advertise("image", 2);
  sensor_msgs::ImagePtr img_msg;
  std_msgs::Header header;

  ros::Publisher metadata_pub =
    nh->advertise<ovc2::Metadata>("image_metadata", 2);
  ovc2::Metadata metadata_msg;
  uint8_t *metadata_buf = new uint8_t[256*1024];  // 256k block

  while (ros::ok()) {
    ros::spinOnce();
    uint8_t *img_data = NULL;
    struct timespec ts;
    if (!ovc2->wait_for_image(&img_data, ts)) {
      ROS_ERROR("OVC::wait_for_image() failed");
      continue;
    }
    ovc2->update_autoexposure_loop(img_data);

    // make a userland copy of the dma buffer
    memcpy(metadata_buf, &img_data[1280*1024*2], 256*1024);

    header.stamp.sec = ts.tv_sec;
    header.stamp.nsec = ts.tv_nsec;
    header.frame_id = "ovc2";

    cv::Mat img(cvSize(1280, 1024*2), CV_8UC1, img_data, 1280);
    img_msg = cv_bridge::CvImage(header, "mono8", img).toImageMsg();
    image_pub.publish(img_msg);

    uint32_t num_corners[2];
    uint32_t *meta = (uint32_t *)metadata_buf;
    num_corners[0] = meta[2] & 0xffff;
    num_corners[1] = meta[2] >> 16;
    printf("%6d %6d %0.6f\n", (int)num_corners[0], (int)num_corners[1],
      ovc2->get_exposure());

    for (int img_idx = 0; img_idx < 2; img_idx++) {
      metadata_msg.corner_arrays[img_idx].corners.resize(num_corners[img_idx]);
      uint32_t *p_corners =
        (uint32_t *)(&img_data[1280*1024*2+1024+img_idx*64*1024]);
      // sanity-check the corners
      for (int i = 0; i < (int)num_corners[img_idx]; i++) {
        const uint32_t w = p_corners[i];  // temp to unpack corner table entry
        const float row = (float)((w >>  8) & 0x3ff);
        const float col = (float)((w >> 18) & 0x7ff);
        const float score = (float)(w & 0xff);
        if (row >= 1024 || col >= 1280 || col < 0 || row < 0) {
          printf("%d.%d: bad row,col:  (%d, %d)\n",
            img_idx, i, (int)row, (int)col);
          break;  // if this one is hosed, rest of the table is probably bad
        }
        metadata_msg.corner_arrays[img_idx].corners[i].row = row;
        metadata_msg.corner_arrays[img_idx].corners[i].col = col;
        metadata_msg.corner_arrays[img_idx].corners[i].score = score;
      }
    }
    metadata_msg.header = header;
    metadata_pub.publish(metadata_msg);
  }
  delete[] metadata_buf;
}

void imu_thread_fn(OVC2 *ovc2, ros::NodeHandle *nh)
{
  ros::Publisher imu_pub = nh->advertise<sensor_msgs::Imu>("imu", 2);
  OVC2IMUState imu_state;
  sensor_msgs::Imu imu_msg;
  struct timespec ts;
  while (ros::ok()) {
    if (!ovc2->wait_for_imu_state(imu_state, ts)) {
      ROS_ERROR("oh noes, error reading IMU!");
      continue;
    }
    imu_msg.header.stamp.sec = ts.tv_sec;
    imu_msg.header.stamp.nsec = ts.tv_nsec;
    imu_msg.angular_velocity.x = imu_state.gyro[0];
    imu_msg.angular_velocity.y = imu_state.gyro[1];
    imu_msg.angular_velocity.z = imu_state.gyro[2];
    imu_msg.linear_acceleration.x = imu_state.accel[0];
    imu_msg.linear_acceleration.y = imu_state.accel[1];
    imu_msg.linear_acceleration.z = imu_state.accel[2];
    imu_msg.orientation.x = imu_state.quaternion[0];
    imu_msg.orientation.y = imu_state.quaternion[1];
    imu_msg.orientation.z = imu_state.quaternion[2];
    imu_msg.orientation.w = imu_state.quaternion[3];
    imu_pub.publish(imu_msg);
    // todo: publish pressure and temperature
  }
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "ovc2");
  ros::NodeHandle nh, nh_private("~");

  OVC2 ovc2;
  if (!ovc2.init()) {
    ROS_FATAL("ovc2 init failed");
    return 1;
  }

  ROS_INFO("spinning up worker threads...");
  std::thread cam_thread(cam_thread_fn, &ovc2, &nh);
  std::thread imu_thread(imu_thread_fn, &ovc2, &nh);

  ROS_INFO("starting main spin loop...");
  ros::spin();
  printf("joining worker threads...\n");
  imu_thread.join();
  cam_thread.join();
  printf("done! goodbye.\n");
}
