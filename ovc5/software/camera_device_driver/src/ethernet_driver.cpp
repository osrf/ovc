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
    : imager_mutexes(6),
      imager_condition_variables(6),
      image_ptrs(6) // TODO remove hardcoded 6 (num imagers)
{
  // TODO different ports for different imagers?
  const int IMAGERS_PER_IP = 6 / server_ips.size();
  for (std::size_t i=0; i<server_ips.size(); ++i)
  {
    // Create an equal number of sockets per IP address
    // Undefined if num_imagers % num_sockets > 0
    for (std::size_t s = 0; s < IMAGERS_PER_IP; ++s)
    {
      int sock = socket(AF_INET, SOCK_STREAM, 0);
      struct sockaddr_in sock_in = {0};

      sock_in.sin_family = AF_INET;
      sock_in.sin_port = htons(port + i * IMAGERS_PER_IP + s);

      inet_aton(server_ips[i].c_str(), &sock_in.sin_addr);

      if (connect(sock, (struct sockaddr *)&sock_in, sizeof(sock_in)) < 0)
        std::cout << "Failed connecting to server" << std::endl;

      socks.push_back(Socket(sock));
    }
  }
  for (auto& ptr : image_ptrs)
    ptr = false;

  if (socks.empty())
  {
    throw std::runtime_error("No server connection established.");
  }
}

EthernetClient::~EthernetClient()
{
  stop = true;
  std::cout << "Stopping ethernet threads" << std::endl;
  // Notify all condition variables to stop waiting
  for (auto& cond_var : imager_condition_variables)
    cond_var.notify_all();
  for (auto& thread_it : imager_threads)
  {
    thread_it.second.join();
  }
  std::cout << "Ethernet threads stopped" << std::endl;
}

void EthernetClient::send_thread(I2CCamera* cam, uint8_t camera_id)
{
  std::cout << "Thread started for camera " << (int)camera_id << std::endl;
  auto params = cam->getCameraParams();
  // Initialize a tx packet
  // TODO frame ID
  ether_tx_packet_t tx_pkt = {0};
  tx_pkt.frame.camera_id = camera_id;
  tx_pkt.frame.height = params.res_y;
  tx_pkt.frame.width = params.res_x;
  tx_pkt.frame.bit_depth = params.bit_depth;
  strncpy(
      tx_pkt.frame.data_type, params.data_type, sizeof(tx_pkt.frame.data_type));
  tx_pkt.frame.step = std::round(params.res_x * (params.bit_depth / 8.0));
  const int frame_size = tx_pkt.frame.height * tx_pkt.frame.step;
  while (!stop)
  {
    // Wait for condition variable, image to be ready
    while (image_ptrs[camera_id] == false)
    {
      std::unique_lock<std::mutex> imager_lock(imager_mutexes[camera_id]);
      if (stop)
      {
        return;
      }
      imager_condition_variables[camera_id].wait(imager_lock);
    }
    // Now get the frame from the camera
    unsigned char *imgdata = cam->getFrame(-3);;
    off_t cur_off = 0;
    // First send the header
    const size_t io_size = write(socks[camera_id].num, tx_pkt.data, sizeof(tx_pkt));
    if (io_size != sizeof(tx_pkt))
    {
      std::cout << "TX packet header failed to send" << std::endl;
    }
    while (cur_off < frame_size)
    {
      cur_off += write(socks[camera_id].num, imgdata + cur_off, frame_size - cur_off);
    }
    // Empty the atomic and notify for completion of image send
    image_ptrs[camera_id] = false;
    imager_condition_variables[camera_id].notify_all();
  }
}

void EthernetClient::send_image(I2CCamera* cam, uint8_t camera_id)
{
  /*
  tx_pkt.frame.t_sec = now.sec;
  tx_pkt.frame.t_nsec = now.nsec;
  */
  // Make sure a socket was assigned
  auto thread_it = imager_threads.find(camera_id);
  if (thread_it == imager_threads.end())
  {
    imager_threads.insert({camera_id,
        std::thread(&EthernetClient::send_thread, this, cam, camera_id)});
    std::cout << "Creating thread for imager " << (int)camera_id << std::endl;
  }
  image_ptrs[camera_id] = true;
  imager_condition_variables[camera_id].notify_all();
}

// Wait until all the images have been sent
void EthernetClient::wait_done()
{
  auto t0 = std::chrono::system_clock::now();
  for (std::size_t i = 0; i < socks.size(); ++i)
  {
    std::unique_lock<std::mutex> imager_lock(imager_mutexes[i]);
    while (!stop && image_ptrs[i] != false)
    {
      imager_condition_variables[i].wait(imager_lock);
    }
  }
  /*
  auto t1 = std::chrono::system_clock::now();
  std::chrono::duration<double> diff = t1 - t0;
  std::cout << "sending dt = " << diff.count() << std::endl;
  */
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
  FD_SET(socks[0].num, &rfds);
  int retval = select(socks[0].num + 1, &rfds, NULL, NULL, &timeout);
  if (0 == retval || -1 == retval)
  {
    return nullptr;
  }

  uint16_t json_size = -1;
  size_t io_size = read(socks[0].num, &json_size, sizeof(json_size));
  if (io_size != sizeof(json_size) && io_size != 0)
  {
    std::cout << "RX packet size not received." << std::endl;
  }

  std::string json_string(json_size, 0);
  io_size = read(socks[0].num, &json_string[0], json_size);
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

// TODO implement
void EthernetClient::increaseId() { /*tx_pkt.frame.frame_id++; */}
