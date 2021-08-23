#include "ovc5_driver/ethernet_driver.hpp"

#include <jsoncpp/json/json.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#include <cmath>
#include <iostream>
#include <sstream>

EthernetClient::EthernetClient(const std::vector<std::string> &server_ips,
                               int port)
    : base_port(port)
{
  // TODO different ports for different imagers?
  for (auto ip : server_ips)
  {
    int sock = socket(AF_INET, SOCK_STREAM, 0);

    sock_in.sin_family = AF_INET;
    sock_in.sin_port = htons(base_port);

    inet_aton(ip.c_str(), &sock_in.sin_addr);

    if (connect(sock, (struct sockaddr *)&sock_in, sizeof(sock_in)) < 0)
      std::cout << "Failed connecting to server" << std::endl;

    socks.push_back(sock);
  }

  if (socks.empty())
  {
    throw std::runtime_error("No server connection established.");
  }
  // TODO all those from parameters
  strncpy(tx_pkt.frame.sensor_name, cam_name, sizeof(*cam_name));
  strncpy(tx_pkt.frame.data_type, cam_data_type, sizeof(*cam_data_type));

  tx_pkt.frame.frame_id = 0;
}

void EthernetClient::send_image(uint8_t camera_id, unsigned char *imgdata,
                                const camera_params_t &params)
{
  /*
  tx_pkt.frame.t_sec = now.sec;
  tx_pkt.frame.t_nsec = now.nsec;
  strncpy(tx_pkt.frame.camera_name, camera_name.c_str(), camera_name.size());
  */
  tx_pkt.frame.camera_id = camera_id;
  tx_pkt.frame.height = params.res_y;
  tx_pkt.frame.width = params.res_x;
  strncpy(tx_pkt.frame.data_type, params.data_type, sizeof(params.data_type));
  tx_pkt.frame.step = std::round(params.res_x * (params.bit_depth / 8.0));
  int frame_size = tx_pkt.frame.height * tx_pkt.frame.step;
  int cur_off = 0;

  // First send the header
  size_t io_size = write(socks[0], tx_pkt.data, sizeof(tx_pkt));
  if (io_size != sizeof(tx_pkt))
  {
    std::cout << "TX packet header failed to send" << std::endl;
  }
  while (cur_off < frame_size)
  {
    cur_off += write(socks[0], imgdata + cur_off, frame_size - cur_off);
  }
}

ether_rx_packet_t *EthernetClient::recv()
{
  // This logic checks if there is data and returns nullptr if no data to recv
  // on the socket.
  struct timeval timeout;
  timeout.tv_sec = 0;
  timeout.tv_usec = 10;
  fd_set rfds;
  FD_ZERO(&rfds);
  FD_SET(socks[0], &rfds);
  int retval = select(socks[0] + 1, &rfds, NULL, NULL, &timeout);
  if (0 == retval || -1 == retval)
  {
    return nullptr;
  }

  size_t io_size = read(socks[0], rx_pkt.data, sizeof(rx_pkt));
  // Do not warn if empty.
  if (io_size != sizeof(rx_pkt) && io_size != 0)
  {
    std::cout << "RX packet header not received in full" << std::endl;
  }
  return &rx_pkt;
}

std::shared_ptr<Json::Value> EthernetClient::recv_json()
{
  // This logic checks if there is data and returns nullptr if no data to recv
  // on the socket.
  struct timeval timeout;
  timeout.tv_sec = 0;
  timeout.tv_usec = 10;
  fd_set rfds;
  FD_ZERO(&rfds);
  FD_SET(socks[0], &rfds);
  int retval = select(socks[0] + 1, &rfds, NULL, NULL, &timeout);
  if (0 == retval || -1 == retval)
  {
    return nullptr;
  }

  uint16_t json_size = -1;
  size_t io_size = read(socks[0], &json_size, sizeof(json_size));
  if (io_size != sizeof(json_size) && io_size != 0)
  {
    std::cout << "RX packet size not received." << std::endl;
  }

  std::string json_string(json_size, 0);
  io_size = read(socks[0], &json_string[0], json_size);
  if (io_size != json_size && io_size != 0)
  {
    std::cout << "JSON packet not fully received." << std::endl;
  }

  std::cout << "Received JSON:" << std::endl << json_string << std::endl;
  std::stringstream ss(json_string);
  auto root = std::shared_ptr<Json::Value>(new Json::Value());
  std::string errs;
  Json::CharReaderBuilder rbuilder;
  Json::parseFromStream(rbuilder, ss, root.get(), &errs);
  return root;
}

void EthernetClient::increaseId() { tx_pkt.frame.frame_id++; }
