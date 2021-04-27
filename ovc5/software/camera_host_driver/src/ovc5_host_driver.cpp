#include <iostream>
#include <thread>

#include "subscriber.hpp"

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

static cv::Mat unpackTo16(const cv::Mat& frame)
{
  cv::Mat ret(frame.rows, frame.cols, CV_16UC1);
  uint8_t* frame_data = frame.data;
  uint16_t* target_data = (uint16_t*)ret.data;
  int idx = 0;
  for (int r = 0; r < frame.rows; ++r)
  {
    for (int c = 0; c < frame.cols; c += 2)
    {
      // First pixel
      target_data[r * ret.cols + c] = frame_data[idx];
      target_data[r * ret.cols + c] |= ((uint16_t)frame_data[idx + 1] & 0xF)
                                       << 8;
      target_data[r * ret.cols + c] <<= 4;
      // Second pixel
      target_data[r * ret.cols + c + 1] = frame_data[idx + 1] >> 4;
      target_data[r * ret.cols + c + 1] |= (uint16_t)frame_data[idx + 2] << 4;
      target_data[r * ret.cols + c + 1] <<= 4;
      idx += 3;
    }
  }
  return ret;
}

int main(int argc, char** argv)
{
  Subscriber sub;
  std::thread thread(&Subscriber::receiveThread, &sub);
  while (1)
  {
    auto frames = sub.getFrames();
    std::cout << "Got a pair of frames" << std::endl;
    cv::Mat frame1, frame2;
    cv::Mat shifted1 = unpackTo16(frames[0].image);
    cv::Mat shifted2 = unpackTo16(frames[1].image);
    cv::cvtColor(shifted1, frame1, cv::COLOR_BayerBG2BGR);
    cv::cvtColor(shifted2, frame2, cv::COLOR_BayerBG2BGR);
    cv::imshow("Right", frame1);
    // cv::imwrite("frame.png", frame1);
    cv::imshow("Left", frame2);
    cv::waitKey(1);
  }
  thread.join();
  return 0;
}
