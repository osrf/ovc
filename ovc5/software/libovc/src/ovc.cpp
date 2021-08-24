#include "libovc/ovc.hpp"

#include <iomanip>
#include <thread>

#include "libovc/ethernet_packetdef.hpp"
#include "libovc/server.hpp"

namespace libovc
{
static cv::Mat unpack12To16(const cv::Mat &frame)
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

static cv::Mat unpack10To16(const cv::Mat &frame)
{
  cv::Mat ret(frame.rows, frame.cols, CV_16UC1);
  uint8_t *in8 = frame.data;
  uint16_t *out16 = (uint16_t *)ret.data;

  size_t n = frame.cols * frame.rows;
  uint16_t a, b, c, d, split;

  for (n /= 4; n--;)
  {
    a = *in8++;
    b = *in8++;
    c = *in8++;
    d = *in8++;
    split = *in8++;
    *out16++ = (((uint16_t)a << 2) | ((split >> 0) & 0x3)) << 6;
    *out16++ = (((uint16_t)b << 2) | ((split >> 2) & 0x3)) << 6;
    *out16++ = (((uint16_t)c << 2) | ((split >> 4) & 0x3)) << 6;
    *out16++ = (((uint16_t)d << 2) | ((split >> 6) & 0x3)) << 6;
  }

  return ret;
}

static cv::Mat unpackTo16(const cv::Mat &frame, uint8_t bit_depth)
{
  switch (bit_depth)
  {
    case 10:
      return unpack10To16(frame);
    case 12:
      return unpack12To16(frame);
  }
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
    cv::Mat shifted = unpackTo16(frame.image, frame.bit_depth);
    cv::cvtColor(shifted, frame.image, frame.color_format);
  }

  return frames_;
}

void OVC::updateConfig(const Json::Value &root) { server_.updateConfig(root); }

}  // namespace libovc
