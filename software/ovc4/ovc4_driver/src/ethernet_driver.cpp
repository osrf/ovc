
#include <ovc4_driver/ethernet_driver.hpp>

#include <sys/socket.h>
#include <unistd.h>
#include <string.h>
#include <iostream>

EthernetPublisher::EthernetPublisher(int cam_id, const std::string& camera_name)
{
  // TODO different ports for different imagers?
  sock = socket(AF_INET, SOCK_STREAM, 0);

  sock_in.sin_family = AF_INET;
  sock_in.sin_port = htons(BASE_PORT + cam_id);

  inet_aton(SERVER_IP, &sock_in.sin_addr);

  if (connect(sock, (struct sockaddr *) &sock_in, sizeof(sock_in)) < 0)
    std::cout << "Failed connecting to server" << std::endl;

  // TODO all those from parameters
  pkt.frame.height = 1944 * 1.5;
  pkt.frame.width = 2592;
  pkt.frame.step = 2592;
  strncpy(pkt.frame.sensor_name, "ar0521", sizeof("ar0521"));
  strncpy(pkt.frame.camera_name, camera_name.c_str(), camera_name.size());
  strncpy(pkt.frame.data_type, "yuv420", sizeof("yuv420"));

  pkt.frame.frame_id = 0;
}

void EthernetPublisher::publish(std::shared_ptr<OVCImage> imgptr, const ros::Time& now)
{
  pkt.frame.t_sec = now.sec;
  pkt.frame.t_nsec = now.nsec;
  int frame_size = pkt.frame.height * pkt.frame.step;
  int cur_off = 0;
  char payload[32768];
  int num_packets = frame_size / TCP_PACKET_SIZE;
  // Send
  //for (int i = 0; i < INT32_MAX; ++i)
  {
    cur_off = 0;
    // First send the header
    write(sock, pkt.data, sizeof(pkt));
    for (int i = 0; i < num_packets; ++i)
    {
      write(sock, &imgptr->image.data[cur_off], TCP_PACKET_SIZE);
      cur_off += TCP_PACKET_SIZE;
      //usleep(10000);
    }
    // Now the extra bytes
    write(sock, &imgptr->image.data[cur_off], frame_size - cur_off);
    //std::cout << "Publishing packet n. " << i << std::endl;
    pkt.frame.frame_id++;
    //usleep(30000);
  }
    
}
