#ifndef ETHERNET_DRIVER_INC
#define ETHERNET_DRIVER_INC

#include <arpa/inet.h>
#include <jsoncpp/json/json.h>

#include <string>

#include "ovc5_driver/camera.hpp"
#include "ovc5_driver/ethernet_packetdef.hpp"

// Publisher for sequential images
class EthernetClient
{
private:
  int base_port;

  struct sockaddr_in sock_in = {0};
  std::vector<int> socks;

  ether_tx_packet_t tx_pkt = {0};
  ether_rx_packet_t rx_pkt = {0};

  const char *cam_name = "picamv2";
  const char *cam_data_type = "rggb16";

public:
  EthernetClient(const std::vector<std::string> &server_ips, int port = 12345);

  // TODO proper timestamping and packet header
  void send_image(uint8_t camera_id, unsigned char *imgdata,
                  const camera_params_t &params);

  // Returns the packet type received.
  ether_rx_packet_t *recv();

  // Waits to receive a json message.
  std::shared_ptr<Json::Value> recv_json();

  void increaseId();
};

#endif
