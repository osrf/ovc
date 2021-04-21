#ifndef ETHERNET_DRIVER_INC
#define ETHERNET_DRIVER_INC

#include <arpa/inet.h>

#include <libovc/ethernet_packetdef.hpp>

#include "ovc5_driver/camera.hpp"

// Publisher for sequential images
class EthernetClient
{
private:
  static constexpr char* SERVER_IP = "10.0.1.2";

  int base_port;

  struct sockaddr_in sock_in = {sizeof(sockaddr_in)};
  int sock;

  ether_tx_packet_t tx_pkt = {sizeof(ether_tx_packet_t)};
  ether_rx_packet_t rx_pkt = {sizeof(ether_rx_packet_t)};

public:
  EthernetClient(int port = 12345);

  // TODO proper timestamping and packet header
  void send(unsigned char* imgdata, const camera_params_t& params);

  // Returns the packet type received.
  ether_rx_packet_type_t recv();

  void increaseId();

};

// Publishes two frames in parallel on different ports
class StereoEthernetClient
{
private:
  // TODO parametrize num cameras
  EthernetClient clients[2];


public:
  StereoEthernetClient();
};





#endif
