#ifndef __SUBSCRIBER_HPP
#define __SUBSCRIBER_HPP

#include <arpa/inet.h>
#include <sys/socket.h>

#include <opencv2/opencv.hpp>

#include <atomic>
#include <condition_variable>
#include <mutex>

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
  cv::Mat image;
} OVCImage;

class Subscriber
{
public:
  static constexpr int NUM_IMAGERS = 2;

private:
  static constexpr int BASE_PORT = 12345;

  ReceiveState state_ = ReceiveState::WAIT_HEADER;

  struct sockaddr_in si_self = {0}, si_other = {0};
  int sock;
  int recv_sock;

  std::array<OVCImage, NUM_IMAGERS> ret_imgs;

  std::atomic<int> frames_received = {0};
  std::condition_variable frames_ready_var;
  std::mutex frames_ready_mutex;
  std::mutex frames_mutex;
  std::unique_lock<std::mutex> frames_ready_guard;

public:
  Subscriber();
  ~Subscriber();

  void receiveThread();

  std::array<OVCImage, NUM_IMAGERS> getFrames();

};

#endif // SUBSCRIBER_HPP
