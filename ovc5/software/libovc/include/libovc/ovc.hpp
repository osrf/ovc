#ifndef __OVC_HPP
#define __OVC_HPP

#include <jsoncpp/json/json.h>

#include <thread>

#include "libovc/ethernet_packetdef.hpp"
#include "libovc/server.hpp"

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
  void updateConfig(const Json::Value &root);

  int getNumImagers() { return Server::NUM_IMAGERS; }
};

}  // namespace libovc

#endif  // OVC_HPP
