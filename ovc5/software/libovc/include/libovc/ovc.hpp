#ifndef __OVC_HPP
#define __OVC_HPP

#include "server.hpp"

namespace libovc {

class OVC {
private:
  std::array<OVCImage, Server::NUM_IMAGERS> frames_;
  Server server_;
  std::thread thread_;

public:
  OVC();
  ~OVC();

  std::array<OVCImage, Server::NUM_IMAGERS> getFrames();
  void updateConfig(double exposure);

  int getNumImagers() { return Server::NUM_IMAGERS; }
};

} // namespace libovc

#endif // OVC_HPP
