#ifndef __SERVER_HPP
#define __SERVER_HPP

#include <arpa/inet.h>
#include <jsoncpp/json/json.h>
#include <sys/socket.h>

#include <atomic>
#include <condition_variable>
#include <mutex>
#include <thread>
#include <opencv2/opencv.hpp>
#include <unordered_map>

#include "libovc/ethernet_packetdef.hpp"

namespace libovc
{
enum class ReceiveState
{
  WAIT_HEADER,
  WAIT_PAYLOAD,
};

// TODO sensor name / mode?
typedef struct OVCImage
{
  uint64_t t_sec;
  uint64_t t_nsec;
  uint64_t frame_id;
  uint8_t bit_depth;
  cv::ColorConversionCodes color_format;
  cv::Mat image;
} OVCImage;

class Server
{
private:
  static constexpr int BASE_PORT = 12345;
  static constexpr int NUM_INTERFACES = 1; // Two USB ethernets in parallel

  // The Bayer Pattern is as follows:
  //
  //     * * * * * * * * * *
  //     * R G R G R G R G *
  //     * G B G B G B G B *
  //     * * * * * * * * * *
  //
  // Depending on the direction x and y increment when reading out the data,
  // the order will change. This order determines the selection within the
  // color map.
  const std::unordered_map<std::string, cv::ColorConversionCodes>
      color_code_map = {
          {"ByrRGGB", cv::COLOR_BayerBG2BGR},  // Left to Right, Top to Bottom.
          {"ByrGRBG", cv::COLOR_BayerGR2RGB},  // Right to Left, Top to Bottom.
  };

  ReceiveState state_ = ReceiveState::WAIT_HEADER;

  bool stop_ = false;
  int param_sock;

  std::unordered_map<uint8_t, OVCImage> ret_imgs;

  std::atomic<int> frames_received = {0};
  std::condition_variable frames_ready_var;
  std::mutex frames_ready_mutex;
  std::mutex frames_mutex;
  std::unique_lock<std::mutex> frames_ready_guard;
  std::vector<std::thread> threads;

  void receiveThread(int port_offset);

  std::vector<std::thread> createThreads();

public:
  Server();
  ~Server();

  std::unordered_map<uint8_t, OVCImage> getFrames();

  void updateConfig(const Json::Value &root);
};

}  // namespace libovc

#endif  // SERVER_HPP
