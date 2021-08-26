#include "libovc/ovc.hpp"

#include <jsoncpp/json/json.h>

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

std::array<OVCImage, Server::NUM_IMAGERS> OVC::getFrames()
{
  frames_ = server_.getFrames();
  for (size_t i = 0; i < frames_.size(); i++)
  {
    cv::Mat shifted = unpackTo16(frames_[i].image);
    cv::cvtColor(shifted, frames_[i].image, frames_[i].color_format);
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
