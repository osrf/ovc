#ifndef __OVC_HPP
#define __OVC_HPP

#include <thread>

#include "libovc/ethernet_packetdef.hpp"
#include "libovc/server.hpp"

#define config_t ether_rx_config_t

namespace libovc
{
class OVC
{
private:
  std::array<OVCImage, Server::NUM_IMAGERS> frames_;
  Server server_;
  std::thread thread_;

public:
  OVC();
  ~OVC();

  std::array<OVCImage, Server::NUM_IMAGERS> getFrames();
  void updateConfig(config_t config);

  int getNumImagers() { return Server::NUM_IMAGERS; }
};

}  // namespace libovc

#endif  // OVC_HPP
