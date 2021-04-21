#include <sys/socket.h>
#include <unistd.h>
#include <string.h>
#include <iostream>
#include <cmath>

#include "ovc5_driver/ethernet_driver.hpp"

EthernetClient::EthernetClient(int port) :
  base_port(port)
{
  // TODO different ports for different imagers?
  sock = socket(AF_INET, SOCK_STREAM, 0);

  sock_in.sin_family = AF_INET;
  sock_in.sin_port = htons(base_port);

  inet_aton(SERVER_IP, &sock_in.sin_addr);

  if (connect(sock, (struct sockaddr *) &sock_in, sizeof(sock_in)) < 0)
    std::cout << "Failed connecting to server" << std::endl;

  // TODO all those from parameters
  strncpy(pkt.frame.sensor_name, "picamv2", sizeof("picamv2"));
  strncpy(pkt.frame.data_type, "rggb16", sizeof("rggb16"));

  pkt.frame.frame_id = 0;
}

void EthernetClient::send(unsigned char* imgdata, const camera_params_t& params)
{
  /*
  pkt.frame.t_sec = now.sec;
  pkt.frame.t_nsec = now.nsec;
  strncpy(pkt.frame.camera_name, camera_name.c_str(), camera_name.size());
  */
  pkt.frame.height = params.res_y;
  pkt.frame.width = params.res_x;
  pkt.frame.step = std::round(params.res_x * (params.bit_depth / 8.0));
  int frame_size = pkt.frame.height * pkt.frame.step;
  int cur_off = 0;
  // First send the header
  write(sock, pkt.data, sizeof(pkt));
  while (cur_off < frame_size)
  {
    cur_off += write(sock, imgdata + cur_off, frame_size - cur_off);
  }
}

void EthernetClient::increaseId()
{
  pkt.frame.frame_id++;
}

StereoEthernetClient::StereoEthernetClient() :
  clients{12345, 12346}
{

}
