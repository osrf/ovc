#include "libovc/server.hpp"

#include <unistd.h>

#include <iostream>

#include "libovc/ethernet_packetdef.hpp"

namespace libovc
{
Server::Server() : frames_ready_guard(frames_ready_mutex)
{
  stop_ = false;

  sock = socket(AF_INET, SOCK_STREAM, 0);

  si_self.sin_family = AF_INET;
  si_self.sin_port = htons(BASE_PORT);
  si_self.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(sock, (struct sockaddr *)&si_self, sizeof(si_self));
}

Server::~Server()
{
  close(sock);
  close(recv_sock);
}

// TODO atomic to signal from receive thread and mutexes to avoid corrupted
// frames
std::array<OVCImage, Server::NUM_IMAGERS> Server::getFrames()
{
  while (frames_received / NUM_IMAGERS == 0)
  {
    frames_ready_var.wait(frames_ready_guard);
  }
  frames_received = 0;
  // Lock mutex to avoid overwriting in receive thread
  std::lock_guard<std::mutex> lock(frames_mutex);
  return ret_imgs;
}

void Server::stop() { stop_ = true; }

void Server::receiveThread()
{
  unsigned int si_size = sizeof(si_other);
  listen(sock, 1);
  recv_sock = accept(sock, (struct sockaddr *)&si_other, &si_size);
  // TODO proper while condition
  size_t cur_off = 0;
  size_t frame_size = 0;
  int camera_id = 0;
  std::unique_lock<std::mutex> frames_lock(frames_mutex, std::defer_lock);
  ether_tx_packet_t recv_pkt;
  while (!stop_)
  {
    std::string camera_name;
    if (state_ == ReceiveState::WAIT_HEADER)
    {
      // Receive a header
      if (cur_off > sizeof(recv_pkt))
      {
        // We received a whole header and a beginning of frame before finishing
        // reading the previous one
        throw std::runtime_error("UNHANDLED CASE ERROR");
      }
      else
      {
        while (cur_off < sizeof(recv_pkt))
        {
          int recv_len = recv(recv_sock, &recv_pkt.data[cur_off],
                              sizeof(recv_pkt) - cur_off, MSG_WAITALL);
          cur_off += recv_len;
        }
      }

      ret_imgs[camera_id].t_sec = recv_pkt.frame.t_sec;
      ret_imgs[camera_id].t_nsec = recv_pkt.frame.t_nsec;
      ret_imgs[camera_id].frame_id = recv_pkt.frame.frame_id;

      frame_size = recv_pkt.frame.height * recv_pkt.frame.step;
      camera_name = recv_pkt.frame.camera_name;

      // Create ovc buffer for pre-processing (need to convert to 16bit before
      // publishing).
      ret_imgs[camera_id].image.create(
          recv_pkt.frame.height, recv_pkt.frame.width,
          CV_16UC1);  // TODO flexible data type, for now only yuv420

      cur_off = 0;
      state_ = ReceiveState::WAIT_PAYLOAD;
    }
    else if (state_ == ReceiveState::WAIT_PAYLOAD)
    {
      frames_lock.lock();
      while (cur_off < frame_size)
      {
        int recv_len = recv(recv_sock, &ret_imgs[camera_id].image.data[cur_off],
                            frame_size - cur_off, MSG_WAITALL);
        cur_off += recv_len;
      }
      frames_lock.unlock();
      cur_off -= frame_size;

      state_ = ReceiveState::WAIT_HEADER;
      ++frames_received;
      if (frames_received % NUM_IMAGERS == 0)
      {
        // All frames received, notify userspace
        frames_ready_var.notify_all();
      }
      camera_id = (camera_id + 1) % NUM_IMAGERS;
    }
  }
}

void Server::updateConfig(ether_rx_config_t config)
{
  ether_rx_packet_t send_pkt;
  send_pkt.status = 0;
  send_pkt.packet_type = RX_PACKET_TYPE_CMD_CONFIG;
  send_pkt.config = config;
  size_t io_size = write(recv_sock, send_pkt.data, sizeof(send_pkt));
  if (io_size != sizeof(send_pkt))
  {
    std::cout << "libovc: Failed to write full config packet" << std::endl;
  }
}

}  // namespace libovc
