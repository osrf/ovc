#ifndef __OVC_HPP
#define __OVC_HPP

#include <jsoncpp/json/json.h>

#include <thread>
#include <unordered_map>

#include "libovc/ethernet_packetdef.hpp"
#include "libovc/server.hpp"

namespace libovc
{
class OVC
{
private:
  std::unordered_map<uint8_t, OVCImage> frames_;
  Server server_;
  std::thread thread_;

public:
  OVC();
  ~OVC();

  std::unordered_map<uint8_t, OVCImage> getFrames();
  void updateConfig(const Json::Value &root);
};

}  // namespace libovc

#endif  // OVC_HPP
