#ifndef __OVC_HPP
#define __OVC_HPP

#include "subscriber.hpp"

namespace libovc {

class OVC {
private:
  std::array<OVCImage, Subscriber::NUM_IMAGERS> frames_;
  Subscriber subscriber_;
  std::thread thread_;

public:
  OVC();
  ~OVC();

  std::array<OVCImage, Subscriber::NUM_IMAGERS> getFrames();

  int getNumImagers() { return Subscriber::NUM_IMAGERS; }
};

} // namespace libovc

#endif // OVC_HPP
