#ifndef ETHERNET_DRIVER_INC
#define ETHERNET_DRIVER_INC

#include <arpa/inet.h>

#include <ovc4_driver/camera.hpp>
#include <ovc4_driver/ethernet_packetdef.h>
#include <ros/ros.h>

class EthernetPublisher
{
private:
  static constexpr char* SERVER_IP = "192.168.55.100";
  //static constexpr char* SERVER_IP = "127.0.0.1";
  static constexpr int BASE_PORT = 12345;
  static constexpr size_t TCP_PACKET_SIZE = 32768;

  struct sockaddr_in sock_in = {0};
  int sock;

  ether_tx_packet_t pkt = {0};

public:
  EthernetPublisher();

  void publish(std::shared_ptr<OVCImage> imgptr, const ros::Time& now, const std::string& camera_name);

  void increaseId();

};





#endif
