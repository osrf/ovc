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

  struct sockaddr_in sock_in = {0};
  int sock;

  ether_tx_packet_t pkt = {0};

public:
  EthernetClient(int port = 12345);

  // TODO proper timestamping and packet header
  void send(unsigned char* imgdata, const camera_params_t& params);

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
