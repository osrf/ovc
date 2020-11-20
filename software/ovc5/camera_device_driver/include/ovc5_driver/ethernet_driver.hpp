#ifndef ETHERNET_DRIVER_INC
#define ETHERNET_DRIVER_INC

#include <arpa/inet.h>

#include <ovc5_driver/camera.hpp>
#include <ovc5_driver/ethernet_packetdef.h>

class EthernetPublisher
{
private:
  static constexpr char* SERVER_IP = "10.0.1.2";
  //static constexpr char* SERVER_IP = "127.0.0.1";
  static constexpr int BASE_PORT = 12345;
  static constexpr size_t TCP_PACKET_SIZE = 32768;

  struct sockaddr_in sock_in = {0};
  int sock;

  ether_tx_packet_t pkt = {0};

public:
  EthernetPublisher();

  // TODO proper timestamping and packet header
  void publish(unsigned char* imgdata);

  void increaseId();

};





#endif
