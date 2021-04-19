#include <thread>

#include "libovc/ovc.hpp"
#include "libovc/subscriber.hpp"

namespace libovc {
static cv::Mat unpackTo16(const cv::Mat &frame) {
  cv::Mat ret(frame.rows, frame.cols, CV_16UC1);
  uint8_t *in8 = frame.data;
  uint16_t *out16 = (uint16_t *)ret.data;

  size_t n = frame.cols * frame.rows;
  unsigned full, half;

  for (n /= 2; n--;) {
    full = *in8++;
    half = *in8++;
    *out16++ = ((((uint16_t)half & 0xF) << 8) | full) << 4;

    full = *in8++;
    *out16++ = ((half >> 4) | ((uint16_t)full << 4)) << 4;
  }

  return ret;
}

OVC::OVC() {
  // Start the subscriber thread (collects images).
  thread_ = std::thread(&Subscriber::receiveThread, &subscriber_);
}

OVC::~OVC() {
  subscriber_.stop();
  thread_.join();
}

std::array<OVCImage, Subscriber::NUM_IMAGERS> OVC::getFrames() {
  frames_ = subscriber_.getFrames();

  for (int i = 0; i < frames_.size(); i++) {
    cv::Mat shifted = unpackTo16(frames_[i].image);
    cv::cvtColor(shifted, frames_[i].image, cv::COLOR_BayerBG2RGB);
  }

  return frames_;
}
} // namespace libovc
