#include <thread>
#include <iostream>

#include <opencv2/opencv.hpp>

#include <libovc/ovc.hpp>

static void dumpFrame(const cv::Mat& frame)
{
  static bool ran = false;
  if (ran)
    return;
  std::ofstream out_file;
  out_file.open("raw_image");
  for (int r = 0; r < frame.rows; ++r)
  {
    for (int c = 0; c < frame.cols; ++c)
    {
      int pixel = frame.at<uint16_t>(r,c);
      out_file << pixel << " ";
    }
    out_file << std::endl;
  }
  ran = true;
}

int main(int argc, char **argv)
{
  libovc::OVC ovc;

  while (1)
  {
    auto frames = ovc.getFrames();
    std::cout << "Got a pair of frames" << std::endl;
    cv::imshow("Right", frames[0].image);
    cv::imshow("Left", frames[1].image);
    cv::waitKey(1);
  }
  return 0;
}
