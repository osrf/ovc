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
    : socks_mutexes(server_ips.size()),
      imager_mutexes(6),
      imager_condition_variables(6),
      image_ptrs(6) // TODO remove hardcoded 6 (num imagers)
{
  // TODO different ports for different imagers?
  for (std::size_t i=0; i<server_ips.size(); ++i)
  {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in sock_in = {0};

    sock_in.sin_family = AF_INET;
    sock_in.sin_port = htons(port + i);

    inet_aton(server_ips[i].c_str(), &sock_in.sin_addr);

    if (connect(sock, (struct sockaddr *)&sock_in, sizeof(sock_in)) < 0)
      std::cout << "Failed connecting to server" << std::endl;

    image_ptrs[i] = false;

    socks.push_back(Socket(sock));
  }

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

std::size_t EthernetClient::assign_to_socket(uint8_t camera_id,
                                      const camera_params_t &params)
{
  // In Mbit / sec
  const std::size_t needed_bw = params.res_x * params.res_y * params.fps *
      params.bit_depth / (1024 * 1024);
  // Find the socket with the most available bandwidth
  int min_usage = socks[0].used_bw, min_idx = 0;
  for (std::size_t i=0; i<socks.size(); ++i)
  {
    if (socks[i].used_bw < min_usage)
    {
      min_usage = socks[i].used_bw;
      min_idx = i;
    }
  }
  std::cout << "Assigning imager " << (int)camera_id << " to socket " << min_idx <<
      " requested bw = " << needed_bw << std::endl;
  if (min_usage + needed_bw > USB_MAX_BW)
  {
    std::cout << "Warning, requested bandwidth of " << min_usage + needed_bw <<
        " but only " << USB_MAX_BW << " is available" << std::endl;
  }
  imager_to_socket[camera_id] = min_idx;
  socks[min_idx].used_bw += needed_bw;
  return min_idx;
}

void EthernetClient::send_thread(I2CCamera* cam, uint8_t camera_id)
{
  std::cout << "Thread started for camera " << (int)camera_id << std::endl;
  auto params = cam->getCameraParams();
  const std::size_t sock_idx = assign_to_socket(camera_id, params);
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
    // We are using the socket, wait for available then lock the mutex
    // Now get the frame from the camera
    unsigned char* imgdata = cam->getFrame(-3);;
    std::lock_guard<std::mutex> socket_lock(socks_mutexes[sock_idx]);
    // The image is being sent, lock the image pointer
    std::lock_guard<std::mutex> imager_lock(imager_mutexes[camera_id]);
    int cur_off = 0;
    // First send the header
    const size_t io_size = write(socks[sock_idx].num, tx_pkt.data, sizeof(tx_pkt));
    if (io_size != sizeof(tx_pkt))
    {
      std::cout << "TX packet header failed to send" << std::endl;
    }
    while (cur_off < frame_size)
    {
      cur_off += write(socks[sock_idx].num, imgdata + cur_off, frame_size - cur_off);
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
  // Make sure we don't overwrite the pointer while it's being sent
  std::lock_guard<std::mutex> imager_lock(imager_mutexes[camera_id]);
  image_ptrs[camera_id] = true;
  imager_condition_variables[camera_id].notify_all();
}

// Wait until all the images have been sent
void EthernetClient::wait_done()
{
  auto t0 = std::chrono::system_clock::now();
  for (const auto& [cam_id, sock] : imager_to_socket)
  {
    std::unique_lock<std::mutex> imager_lock(imager_mutexes[cam_id]);
    while (!stop && image_ptrs[cam_id] != false)
    {
      imager_condition_variables[cam_id].wait(imager_lock);
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
