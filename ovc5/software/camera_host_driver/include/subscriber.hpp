#include <arpa/inet.h>
#include <sys/socket.h>

#include <atomic>
#include <condition_variable>
#include <mutex>
#include <opencv2/opencv.hpp>

#define LATENCY_TEST 1

#include "latency_tester.hpp"

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
private:
  static constexpr int BASE_PORT = 12345;
  static constexpr int NUM_IMAGERS = 2;

  ReceiveState state_ = ReceiveState::WAIT_HEADER;

#if LATENCY_TEST
  LatencyTester tester;
#endif

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
