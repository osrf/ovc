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

static cv::Mat unpackSigned12To16(const cv::Mat &frame)
{
  cv::Mat ret(frame.rows, frame.cols, CV_16SC1);
  uint8_t *in8 = frame.data;
  int16_t *out16 = (int16_t *)ret.data;

  size_t n = frame.cols * frame.rows;
  int16_t a, b, split;
  const int16_t signed_offset = 1 << 12;

  for (n /= 2; n--;)
  {
    a = *in8++;
    b = *in8++;
    split = *in8++;
    *out16 = ((((int16_t)a) << 4) | (split & 0x0F)) << 4;
    *out16 <<= 4;
    *out16 >>= 4;
    ++out16;

    *out16 = ((((int16_t)b) << 4) | ((split >> 4) & 0x0F)) << 4;
    *out16 <<= 4;
    *out16 >>= 4;
    ++out16;
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

static cv::Mat calculateDistance(const cv::Mat &frame_12)
{
  // This function calculates distance on a frame made of four A-B frames at
  // different phases, 90 degrees from each other
  // Split into 4 frames first
  // First translate into signed 12 bit value
  cv::Mat frame = unpackSigned12To16(frame_12);
  cv::Mat phase_0(frame.rows / 4, frame.cols, CV_16SC1);
  cv::Mat phase_90(frame.rows / 4, frame.cols, CV_16SC1);
  cv::Mat phase_180(frame.rows / 4, frame.cols, CV_16SC1);
  cv::Mat phase_270(frame.rows / 4, frame.cols, CV_16SC1);
  frame.rowRange(0 * frame.rows / 4, 1 * frame.rows / 4).copyTo(phase_0.rowRange(0, frame.rows / 4));
  frame.rowRange(1 * frame.rows / 4, 2 * frame.rows / 4).copyTo(phase_90.rowRange(0, frame.rows / 4));
  frame.rowRange(2 * frame.rows / 4, 3 * frame.rows / 4).copyTo(phase_180.rowRange(0, frame.rows / 4));
  frame.rowRange(3 * frame.rows / 4, 4 * frame.rows / 4).copyTo(phase_270.rowRange(0, frame.rows / 4));
  cv::Mat ret(frame.rows / 4, frame.cols, CV_32FC1);
  // Calculate based on datasheet formula
  float *out32 = (float *)ret.data;
  size_t n = frame.cols * frame.rows / 4;
  for (size_t i = 0; i < n; ++i)
  {
    const float modF = 20;
    int p0 = ((int16_t *)phase_0.data)[i];
    int p180 = ((int16_t *)phase_180.data)[i];
    int p90 = ((int16_t *)phase_90.data)[i];
    int p270 = ((int16_t *)phase_270.data)[i];

    int I = p0 - p180;
    int Q = p270 - p90;

    float ampData = sqrt(I*I + Q*Q);
    float Phase = atan2(Q, I);

    float unambiguousrange = 0.5*299792458/(modF*1000);
    float coef_rad = unambiguousrange / (2*M_PI);
    // In meters
    float dist_data = (Phase + M_PI) * coef_rad / 1000.0;

    *out32 = dist_data;
    //printf("[%u] %d,%d,%d,%d - %.2f %.2f\n", ((uint16_t*)frame_12.data)[i], p0, p180, p90, p270, Phase, dist_data);

    ++out32;
  }
  cv::Mat normalized;
  cv::normalize(ret, normalized, 0, 1, cv::NORM_MINMAX, CV_32FC1);
  return normalized;

}

static cv::Mat unpackTo16(const cv::Mat &frame, uint8_t bit_depth, const std::string& data_type)
{
  if (frame.empty())
  {
    throw std::invalid_argument("libovc: unpackTo16 received empty frame");
  }
  // It's a ToF distance frame
  if (data_type == "SCGrscl")
    return calculateDistance(frame);

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
    cv::Mat shifted = unpackTo16(frame.image, frame.bit_depth, frame.data_type);
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
