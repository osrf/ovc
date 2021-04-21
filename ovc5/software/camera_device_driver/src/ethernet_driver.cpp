#include <cmath>
#include <iostream>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#include "ovc5_driver/ethernet_driver.hpp"

EthernetClient::EthernetClient(int port) : base_port(port) {
  // TODO different ports for different imagers?
  sock = socket(AF_INET, SOCK_STREAM, 0);

  sock_in.sin_family = AF_INET;
  sock_in.sin_port = htons(base_port);

  inet_aton(SERVER_IP, &sock_in.sin_addr);

  if (connect(sock, (struct sockaddr *)&sock_in, sizeof(sock_in)) < 0)
    std::cout << "Failed connecting to server" << std::endl;

  // TODO all those from parameters
  strncpy(tx_pkt.frame.sensor_name, cam_name, sizeof(*cam_name));
  strncpy(tx_pkt.frame.data_type, cam_data_type, sizeof(*cam_data_type));

  tx_pkt.frame.frame_id = 0;
}

void EthernetClient::send(unsigned char *imgdata,
                          const camera_params_t &params) {
  /*
  tx_pkt.frame.t_sec = now.sec;
  tx_pkt.frame.t_nsec = now.nsec;
  strncpy(tx_pkt.frame.camera_name, camera_name.c_str(), camera_name.size());
  */
  tx_pkt.frame.height = params.res_y;
  tx_pkt.frame.width = params.res_x;
  tx_pkt.frame.step = std::round(params.res_x * (params.bit_depth / 8.0));
  int frame_size = tx_pkt.frame.height * tx_pkt.frame.step;
  int cur_off = 0;

  // First send the header
  size_t io_size = write(sock, tx_pkt.data, sizeof(tx_pkt));
  if (io_size != sizeof(tx_pkt)) {
    std::cout << "TX packet header failed to send" << std::endl;
  }
  while (cur_off < frame_size) {
    cur_off += write(sock, imgdata + cur_off, frame_size - cur_off);
  }
}

ether_rx_packet_t *EthernetClient::recv() {
  // This logic checks if there is data and returns nullptr if no data to recv
  // on the socket.
  struct timeval timeout;
  timeout.tv_sec = 0;
  timeout.tv_usec = 10;
  fd_set rfds;
  FD_ZERO(&rfds);
  FD_SET(sock, &rfds);
  int retval = select(sock + 1, &rfds, NULL, NULL, &timeout);
  if (0 == retval || -1 == retval) {
    return nullptr;
  }

  size_t io_size = read(sock, rx_pkt.data, sizeof(rx_pkt));
  // Do not warn if empty.
  if (io_size != sizeof(rx_pkt) && io_size != 0) {
    std::cout << "RX packet header not received in full" << std::endl;
  }
  return &rx_pkt;
}

void EthernetClient::increaseId() { tx_pkt.frame.frame_id++; }

StereoEthernetClient::StereoEthernetClient() : clients{12345, 12346} {}
