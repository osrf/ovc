#include "ros/ros.h"
#include "ovc/Metadata.h"
#include "sensor_msgs/Image.h"
#include <cv_bridge/cv_bridge.h>
#include <opencv2/highgui/highgui.hpp>
#include <message_filters/subscriber.h>
#include <message_filters/time_synchronizer.h>
#include <vector>

using sensor_msgs::Image;
using ovc::Metadata;
using message_filters::TimeSynchronizer;

static const int IMG_WIDTH  = 1280;
static const int IMG_HEIGHT = 1024;

#define NUM_IMAGES 1

void sync_cb(const Image::ConstPtr &img_msg, const Metadata::ConstPtr &md_msg)
{
  printf("%6d %6d\n",
    (int)md_msg->corner_arrays[0].corners.size(),
    (int)md_msg->corner_arrays[1].corners.size());
  // first convert the inbound monochrome image to RGB
  cv_bridge::CvImagePtr cv_ptr = cv_bridge::toCvCopy(img_msg, "bgr8");

  cv::Mat cropped;
  if (NUM_IMAGES == 1) {
    // crop image to only camera #1
    cropped = cv_ptr->image(cv::Rect(0, 0, 1280, 1024));
  }
  else
    cropped = cv_ptr->image(cv::Rect(0, 0, 1280, 2048));

  int prev_row = 0, prev_col = 0;
  for (int img_idx = 0; img_idx < NUM_IMAGES; img_idx++) {
    int ncorners = (int)md_msg->corner_arrays[img_idx].corners.size();
    for (int i = 0; i < ncorners; i++) {
      const ovc::ImageCorner *c = &md_msg->corner_arrays[img_idx].corners[i];
      const int row = (int)c->row;
      const int col = (int)c->col;
      if (row == prev_row && col == prev_col) {
        printf("duplicate @ (%d, %d)\n", row, col);
      }
      prev_row = row;
      prev_col = col;
      int score = (int)c->score;
      if (score <   0) score = 0;
      if (score > 127) score = 127;
      int rad = (double)score / 255. * 30.0 + 3;
      cv::circle(cropped, cvPoint(col, row + img_idx*IMG_HEIGHT),
        rad, cvScalar(0, 2*score, 2*(127-score)));
    }
  }
  cv::imshow("corners", cropped);
  cv::waitKey(3);
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "corner_viewer");
  ros::NodeHandle nh, nh_private("~");
  cv::namedWindow("corners",
    CV_WINDOW_NORMAL | CV_WINDOW_KEEPRATIO);  // | CV_WINDOW_OPENGL);
  //cv::setWindowProperty("corners",
  //  CV_WND_PROP_FULLSCREEN, CV_WINDOW_FULLSCREEN);
  message_filters::Subscriber<Image> image_sub(nh, "image", 2);
  message_filters::Subscriber<Metadata> metadata_sub(nh, "image_metadata", 2);
  TimeSynchronizer<Image, Metadata> sync(image_sub, metadata_sub, 10);
  sync.registerCallback(boost::bind(&sync_cb, _1, _2));

  ros::spin();
}
