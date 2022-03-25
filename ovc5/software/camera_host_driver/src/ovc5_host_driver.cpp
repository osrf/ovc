#include <iomanip>
#include <iostream>
#include <libovc/ovc.hpp>
#include <opencv2/opencv.hpp>
#include <thread>

#define SCREEN_WIDTH 3840

/*
static void dumpFrame(const cv::Mat& frame)
{
  static bool ran = false;
  if (ran) return;
  std::ofstream out_file;
  out_file.open("raw_image");
  for (int r = 0; r < frame.rows; ++r)
  {
    for (int c = 0; c < frame.cols; ++c)
    {
      int pixel = frame.at<float>(r, c);
      out_file << pixel << " ";
    }
    out_file << std::endl;
  }
  ran = true;
}

static void saveFrame(const cv::Mat& frame, const std::string& prefix, const std::string& data_type)
{
  static int idx = 0;
  std::string name = prefix + std::to_string(idx) + ".png";
  // Normalize float greyscale image to 0-255 for displaying purposes
  if (data_type == "SCGrscl")
  {
    cv::Mat normalized;
    cv::normalize(frame, normalized, 0, 255, cv::NORM_MINMAX, CV_8UC1);
    cv::imwrite(name.c_str(), normalized);
  }
  else
  {
    cv::imwrite(name.c_str(), frame);
  }
  ++idx;
}

int main(int argc, char** argv)
{
  (void)argc;
  (void)argv;

  libovc::OVC ovc;

  while (1)
  {
    auto frames = ovc.getFrames();

    float scale = 1.0;
    cv::Mat frame, img0 = frames[0].image, img1 = frames[1].image;
    if (img0.rows != img1.rows)
    {
      if (img0.rows > img1.rows)
      {
        scale = (float)img0.rows / img1.rows;
        cv::resize(img1, img1, cv::Size(), scale, scale);
      }
      else
      {
        scale = (float)img1.rows / img0.rows;
        cv::resize(img0, img0, cv::Size(), scale, scale);
      }
    }
    cv::hconcat(img0, img1, frame);
    scale = (float)SCREEN_WIDTH / frame.size().width;
    cv::resize(frame, frame, cv::Size(), scale, scale);
    */
    for (const auto& frame : frames)
    {
      if (frame.second.image.rows > 0 && frame.second.image.cols > 0)
      {
        cv::imshow("ovc_" + std::to_string(frame.first), frame.second.image);
        //saveFrame(frame.second.image, std::string("cam") + std::to_string(frame.first) + std::string("/img_"));
      }

    }
    //cv::imshow("ovc", frames[5].image);
    //dumpFrame(frames[5].image);
    //cv::imshow("ovc2", frames[3].image);
    //saveFrame(frames[0].image, "left_");
    //saveFrame(frames[3].image, "right_");
    cv::waitKey(1);
  }
  return 0;
}
