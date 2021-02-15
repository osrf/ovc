#include <thread>
#include <iostream>

#include <subscriber.hpp>

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
  Subscriber sub;
  std::thread thread(&Subscriber::receiveThread, &sub);
  while (1)
  {
    auto frames = sub.getFrames();
    std::cout << "Got a pair of frames" << std::endl;
    //dumpFrame(frames[0].image);
    //frames[0].image.convertTo(frames[0].image, CV_16UC1, 64, 0.0); //Shift left 4 bits
    //cv::Mat frame1, frame2;
    cv::Mat frame1, frame2;
    cv::cvtColor(frames[0].image, frame1, cv::COLOR_BayerBG2BGR);
    cv::cvtColor(frames[1].image, frame2, cv::COLOR_BayerBG2BGR);
    //dumpFrame(frame1);
    //cv::cvtColor(frames[0].image, frame1, cv::COLOR_YUV2BGR_I420);
    //cv::cvtColor(frames[1].image, frame2, cv::COLOR_YUV2BGR_I420);
    cv::imshow("Right", frame1);
    //cv::imwrite("frame.png", frame1);
    cv::waitKey(1);
    cv::imshow("Left", frame2);
    cv::waitKey(1);
  }
  thread.join();
  return 0;
}
