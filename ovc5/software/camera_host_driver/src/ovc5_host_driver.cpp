#include <iostream>
#include <libovc/ovc.hpp>
#include <opencv2/opencv.hpp>
#include <thread>

#define SCREEN_WIDTH 2560

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
      int pixel = frame.at<uint16_t>(r, c);
      out_file << pixel << " ";
    }
    out_file << std::endl;
  }
  ran = true;
}
*/

int main(int argc, char** argv)
{
  (void)argc;
  (void)argv;

  libovc::OVC ovc;

  while (1)
  {
    auto frames = ovc.getFrames();
    cv::Mat frame;
    cv::hconcat(frames[1].image, frames[2].image, frame);
    float scale = (float)SCREEN_WIDTH / frame.size().width;
    cv::resize(frame, frame, cv::Size(), scale, scale);
    cv::imshow("ovc", frame);
    cv::waitKey(1);
  }
  return 0;
}
