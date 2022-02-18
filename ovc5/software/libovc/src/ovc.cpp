#include "libovc/ovc.hpp"

#include <jsoncpp/json/json.h>

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
  uint16_t a, b, split;

  for (n /= 2; n--;)
  {
    a = *in8++;
    b = *in8++;
    split = *in8++;
    *out16++ = ((((uint16_t)a) << 4) | (split & 0x0F)) << 4;
    *out16++ = ((((uint16_t)b) << 4) | ((split >> 4) & 0x0F)) << 4;
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

static cv::Mat swap16(const cv::Mat &frame)
{
  cv::Mat ret(frame.rows, frame.cols, CV_16UC1);
  uint16_t *in16 = (uint16_t *)frame.data;
  uint16_t *out16 = (uint16_t *)ret.data;

  size_t n = frame.cols * frame.rows;

  for (size_t i = 0; i < n; ++i)
  {
    *out16 = (*in16 << 8) | (*in16 >> 8);
    ++out16;
    ++in16;
  }

  return ret;

}

static cv::Mat unpackTo16(const cv::Mat &frame, uint8_t bit_depth)
{
  if (frame.empty())
  {
    throw std::invalid_argument("libovc: unpackTo16 received empty frame");
  }

  switch (bit_depth)
  {
    case 10:
      return unpack10To16(frame);
    case 12:
      return unpack12To16(frame);
    case 16:
      return swap16(frame);
    default:
      throw std::invalid_argument("libovc: Bit depth " +
                                  std::to_string(bit_depth) + " not supported");
  }
}

std::unordered_map<uint8_t, OVCImage> OVC::getFrames()
{
  for (auto &[id, frame] : server_.getFrames())
  {
    if (frame.image.empty())
    {
      continue;
    }
    cv::Mat shifted = unpackTo16(frame.image, frame.bit_depth);
    cv::cvtColor(shifted, frame.image, frame.color_format);
    frames_[id] = frame;
  }

  return frames_;
}

void OVC::setFrameRate(float frame_rate) { config_["frame_rate"] = frame_rate; }

void OVC::setExposure(int cam_id, float exposure)
{
  Json::Value cam_conf;
  cam_conf["id"] = cam_id;
  cam_conf["exposure"] = exposure;

  config_["cameras"].append(cam_conf);
}

void OVC::updateConfig()
{
  server_.updateConfig(config_);
  config_.clear();
}

}  // namespace libovc
