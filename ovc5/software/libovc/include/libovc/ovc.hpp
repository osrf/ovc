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
  Json::Value config_;

public:
  OVC();
  ~OVC();

  std::array<OVCImage, Server::NUM_IMAGERS> getFrames();

  int getNumImagers() { return Server::NUM_IMAGERS; }

  void setExposure(int cam_id, float exposure);
  void setFrameRate(float frame_rate);
  void updateConfig();
};

}  // namespace libovc

#endif  // OVC_HPP
