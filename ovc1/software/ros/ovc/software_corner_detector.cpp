#include "ros/ros.h"
#include "ovc/Metadata.h"
#include "sensor_msgs/Image.h"
#include <cv_bridge/cv_bridge.h>
#include <opencv2/features2d/features2d.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <message_filters/subscriber.h>
#include <message_filters/time_synchronizer.h>
#include <vector>

using sensor_msgs::Image;
using ovc::Metadata;
using message_filters::TimeSynchronizer;

static cv::Ptr<cv::FastFeatureDetector> g_fast_detector;

//#define DISPLAY_CORNERS

void sync_cb(const Image::ConstPtr &img_msg, const Metadata::ConstPtr &md_msg)
{
  // make monochrome copy of inbound image
  cv_bridge::CvImagePtr gray_copy = cv_bridge::toCvCopy(img_msg, "mono8");
  std::vector<cv::KeyPoint> software_keypoints;
  double t_start = ros::Time::now().toSec();
  g_fast_detector->detect(gray_copy->image, software_keypoints);
  double t_end = ros::Time::now().toSec();
  printf("dt = %0.6f  OpenCV found %d FAST keypoints\n",
    t_end - t_start, (int)software_keypoints.size());

#ifdef DISPLAY_CORNERS
  // now convert the inbound monochrome image to RGB
  cv_bridge::CvImagePtr cv_ptr = cv_bridge::toCvCopy(img_msg, "bgr8");
  //for (int img_idx = 0; img_idx < 2; img_idx++) {
  int ncorners = (int)software_keypoints.size();
  for (int i = 0; i < ncorners; i++) {
    const cv::KeyPoint *kp = &software_keypoints[i];
    const int col = (int)kp->pt.x;
    const int row = (int)kp->pt.y;
    int score = 128;
    cv::circle(cv_ptr->image, cvPoint(col, row),
      3, cvScalar(0, 255-score, score));
    /*
    int score = (int)c->score;
    if (score <   0) score = 0;
    if (score > 255) score = 255;
    //img_rgb.at<cv::Vec3b>(row+img_idx*1024, col) =
    //  cv::Vec3b(255-score,0,score);
     */
  }
  cv::imshow("corners", cv_ptr->image);
  cv::waitKey(3);
#endif
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "corner_viewer");
  ros::NodeHandle nh, nh_private("~");
#ifdef DISPLAY_CORNERS
  cv::namedWindow("corners",
    CV_WINDOW_NORMAL | CV_WINDOW_KEEPRATIO);  // | CV_WINDOW_OPENGL);
#endif
  //cv::setWindowProperty("corners",
  //  CV_WND_PROP_FULLSCREEN, CV_WINDOW_FULLSCREEN);
  g_fast_detector = cv::FastFeatureDetector::create(
    30, true, cv::FastFeatureDetector::TYPE_7_12);

  message_filters::Subscriber<Image> image_sub(nh, "image", 2);
  message_filters::Subscriber<Metadata> metadata_sub(nh, "image_metadata", 2);
  TimeSynchronizer<Image, Metadata> sync(image_sub, metadata_sub, 10);
  sync.registerCallback(boost::bind(&sync_cb, _1, _2));

  ros::spin();
}

