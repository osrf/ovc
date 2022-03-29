#include "libovc/server.hpp"

#include <jsoncpp/json/json.h>
#include <unistd.h>

#include <iostream>

#include "libovc/ethernet_packetdef.hpp"

namespace libovc
{
Server::Server() : frames_ready_guard(frames_ready_mutex)
{
  for (int i=0; i<6; ++i)
  {
    threads.push_back(std::thread(&Server::receiveThread, this, i));
  }
}

Server::~Server()
{
  stop_ = true;
  for (auto& thread : threads)
  {
    thread.join();
  }
}

// TODO atomic to signal from receive thread and mutexes to avoid corrupted
// frames
std::unordered_map<uint8_t, OVCImage> Server::getFrames()
{
  while (frames_received == 0)
  {
    frames_ready_var.wait(frames_ready_guard);
  }
  frames_received = 0;
  // Lock mutex to avoid overwriting in receive thread
  std::lock_guard<std::mutex> lock(frames_mutex);
  return ret_imgs;
}

void Server::receiveThread(int port_offset)
{
  struct sockaddr_in si_self = {0}, si_other = {0};
  int sock = socket(AF_INET, SOCK_STREAM, 0);
  si_self.sin_family = AF_INET;
  si_self.sin_port = htons(BASE_PORT + port_offset);
  si_self.sin_addr.s_addr = htonl(INADDR_ANY);
  bind(sock, (struct sockaddr *)&si_self, sizeof(si_self));

  int recv_sock;
  unsigned int si_size = sizeof(si_other);
  listen(sock, 1);
  recv_sock = accept(sock, (struct sockaddr *)&si_other, &si_size);
  // Socket used for parameters is the first one
  if (port_offset == 0)
  {
    param_sock = recv_sock;
  }
  // TODO proper while condition
  size_t cur_off = 0;
  size_t frame_size = 0;
  uint8_t camera_id = 0;
  std::unique_lock<std::mutex> frames_lock(frames_mutex, std::defer_lock);
  ether_tx_packet_t recv_pkt;
  while (!stop_)
  {
    if (state_ == ReceiveState::WAIT_HEADER)
    {
      // Receive a header
      if (cur_off > sizeof(recv_pkt))
      {
        // We received a whole header and a beginning of frame before finishing
        // reading the previous one
        std::cout << "libovc: Unhandled packet case" << std::endl;
      }
      else
      {
        while (cur_off < sizeof(recv_pkt))
        {
          int recv_len = recv(recv_sock,
                              &recv_pkt.data[cur_off],
                              sizeof(recv_pkt) - cur_off,
                              MSG_WAITALL);
          cur_off += recv_len;
        }
      }

      camera_id = recv_pkt.frame.camera_id;
      // Create new key/value pair if one does not already exist for this
      // camera.
      if (ret_imgs.find(camera_id) == ret_imgs.end())
      {
        ret_imgs[camera_id] = OVCImage();
      }
      ret_imgs[camera_id].t_sec = recv_pkt.frame.t_sec;
      ret_imgs[camera_id].t_nsec = recv_pkt.frame.t_nsec;
      ret_imgs[camera_id].frame_id = recv_pkt.frame.frame_id;
      ret_imgs[camera_id].bit_depth = recv_pkt.frame.bit_depth;
      ret_imgs[camera_id].data_type = recv_pkt.frame.data_type;
      auto data_format = color_code_map.at(recv_pkt.frame.data_type);
      ret_imgs[camera_id].color_format = data_format.color_code;
      // TODO arbitrary widths
      auto bit_type = data_format.is_signed ? CV_16SC1 : CV_16UC1;

      frame_size = recv_pkt.frame.height * recv_pkt.frame.step;

      // Create ovc buffer for pre-processing (need to convert to 16bit before
      // publishing).
      ret_imgs[camera_id].image.create(
          recv_pkt.frame.height,
          recv_pkt.frame.width,
          bit_type);

      cur_off = 0;
      state_ = ReceiveState::WAIT_PAYLOAD;
    }
    else if (state_ == ReceiveState::WAIT_PAYLOAD)
    {
      frames_lock.lock();
      while (cur_off < frame_size)
      {
        int recv_len = recv(recv_sock,
                            &ret_imgs[camera_id].image.data[cur_off],
                            frame_size - cur_off,
                            MSG_WAITALL);
        cur_off += recv_len;
      }
      frames_lock.unlock();
      cur_off -= frame_size;

      state_ = ReceiveState::WAIT_HEADER;
      ++frames_received;
      // A frame has been received, notify userspace.
      frames_ready_var.notify_all();
    }
  }
  close(sock);
  close(recv_sock);
}

void Server::updateConfig(const Json::Value &root)
{
  Json::StreamWriterBuilder builder;
  builder["indentation"] = "";
  std::string output = Json::writeString(builder, root);

  uint16_t output_size = output.size();

  size_t io_size = write(param_sock, &output_size, sizeof(output_size));
  if (io_size != sizeof(output_size))
  {
    std::cout << "libovc: Failed to write json size" << std::endl;
  }

  io_size = write(param_sock, output.c_str(), output_size);
  if (io_size != output_size)
  {
    std::cout << "libovc: Failed to write json" << std::endl;
  }
}

}  // namespace libovc
