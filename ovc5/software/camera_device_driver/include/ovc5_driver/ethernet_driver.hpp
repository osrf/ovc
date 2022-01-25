#ifndef ETHERNET_DRIVER_INC
#define ETHERNET_DRIVER_INC

#include <arpa/inet.h>
#include <jsoncpp/json/json.h>

#include <atomic>
#include <condition_variable>
#include <unordered_map>
#include <string>
#include <thread>

#include "ovc5_driver/camera.hpp"
#include "ovc5_driver/ethernet_packetdef.hpp"

// Publisher for sequential images
class EthernetClient
{
private:
  struct Socket
  {
    int num;
    int used_bw = 0;

    Socket(int num_) : num(num_) {}
  };

  // Max Mbit/s per USB connection (benchmarked)
  static constexpr int USB_MAX_BW = 3200;

  bool stop = false;

  std::vector<Socket> socks;
  std::vector<std::mutex> socks_mutexes;
  std::vector<std::mutex> imager_mutexes;
  std::vector<std::condition_variable> imager_condition_variables;
  std::vector<std::atomic<unsigned char*>> image_ptrs;

  //ether_tx_packet_t tx_pkt = {0};

  std::unordered_map<uint8_t, int> imager_to_socket;
  std::unordered_map<uint8_t, std::thread> imager_threads;

  // Calculates how much bandwidth the camera needs and assigns it
  // to a matching camera interface
  std::size_t assign_to_socket(uint8_t camera_id, const camera_params_t &params);

  void send_thread(uint8_t camera_id, const camera_params_t &params);

public:
  EthernetClient(const std::vector<std::string> &server_ips, int port = 12345);
  ~EthernetClient();

  // TODO proper timestamping and packet header
  void send_image(uint8_t camera_id, unsigned char *imgdata,
                  const camera_params_t &params);

  // Wait until all the images are sent and threads are idle
  void wait_done();

  // Waits to receive a json message.
  std::shared_ptr<Json::Value> recv_json();

  void increaseId();
};

#endif
