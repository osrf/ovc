#include "subscriber.hpp"

#include <unistd.h>

#include "ethernet_packetdef.h"

Subscriber::Subscriber() : frames_ready_guard(frames_ready_mutex)
{
  sock = socket(AF_INET, SOCK_STREAM, 0);

  si_self.sin_family = AF_INET;
  si_self.sin_port = htons(BASE_PORT);
  si_self.sin_addr.s_addr = htonl(INADDR_ANY);

  bind(sock, (struct sockaddr *)&si_self, sizeof(si_self));
}

Subscriber::~Subscriber()
{
  close(sock);
  close(recv_sock);
}

// TODO atomic to signal from receive thread and mutexes to avoid corrupted
// frames
std::array<OVCImage, Subscriber::NUM_IMAGERS> Subscriber::getFrames()
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

void Subscriber::receiveThread()
{
  unsigned int si_size = sizeof(si_other);
  listen(sock, 1);
  recv_sock = accept(sock, (struct sockaddr *)&si_other, &si_size);
  std::cout << "Listening" << std::endl;
  // TODO proper while condition
  int cur_off = 0;
  int frame_size = 0;
  int camera_id = 0;
  std::unique_lock<std::mutex> frames_lock(frames_mutex, std::defer_lock);
  ether_tx_packet_t recv_pkt;
  while (1)
  {
    std::string camera_name;
    if (state_ == ReceiveState::WAIT_HEADER)
    {
      // Receive a header
      if (cur_off > sizeof(recv_pkt))
      {
        // We received a whole header and a beginning of frame before finishing
        // reading the previous one
        std::cout << "UNHANDLED CASE ERROR" << std::endl;
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
      frame_size = recv_pkt.frame.height * recv_pkt.frame.step;
      camera_name = recv_pkt.frame.camera_name;
      // std::cout << "Received a header with frame_id " <<
      // recv_pkt.frame.frame_id <<
      //  " height " << recv_pkt.frame.height << " width = " <<
      //  recv_pkt.frame.width << std::endl;
      // Allocate CV mat
      ret_imgs[camera_id].image.create(
          recv_pkt.frame.height, recv_pkt.frame.width,
          CV_16UC1);  // TODO flexible data type, for now only yuv420
      std::cout << "Frame has " << recv_pkt.frame.height << " rows and "
                << recv_pkt.frame.width << " columns and "
                << recv_pkt.frame.step << " step" << std::endl;
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
#if LATENCY_TEST
        tester.frameReceived();
#endif
        frames_ready_var.notify_all();
      }
      camera_id = (camera_id + 1) % NUM_IMAGERS;
    }
  }
}
