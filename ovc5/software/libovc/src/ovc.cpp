#include "libovc/ovc.hpp"

#include <iomanip>
#include <thread>

#include "libovc/ethernet_packetdef.hpp"
#include "libovc/server.hpp"

namespace libovc
{
static cv::Mat unpackTo16(const cv::Mat &frame)
{
  cv::Mat ret(frame.rows, frame.cols, CV_16UC1);
  uint8_t *in8 = frame.data;
  uint16_t *out16 = (uint16_t *)ret.data;

  size_t n = frame.cols * frame.rows;
  uint16_t full, half;

  for (n /= 2; n--;)
  {
    full = *in8++;
    half = *in8++;
    *out16++ = ((((uint16_t)half & 0xF) << 8) | full) << 4;

    full = *in8++;
    *out16++ = ((half >> 4) | ((uint16_t)full << 4)) << 4;
  }

  return ret;
}

OVC::OVC()
{
  // Start the server thread (collects images).
  thread_ = std::thread(&Server::receiveThread, &server_);
}

OVC::~OVC()
{
  server_.stop();
  thread_.join();
}

std::unordered_map<uint8_t, OVCImage> OVC::getFrames()
{
  frames_ = server_.getFrames();
  for (auto &[id, frame] : frames_)
  {
    cv::Mat shifted = unpackTo16(frame.image);
    cv::cvtColor(shifted, frame.image, frame.color_format);
  }

  return frames_;
}

void OVC::updateConfig(const Json::Value &root) { server_.updateConfig(root); }

}  // namespace libovc
