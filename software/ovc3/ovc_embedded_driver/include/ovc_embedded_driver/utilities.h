#ifndef OVC_UTILITIES_H
#define OVC_UTILITIES_H

#include <mutex>
#include <atomic>

#include <ovc_embedded_driver/sensor_constants.h>
#include <ros/ros.h>

namespace ovc_embedded_driver {

// Class used for multithreaded access / update of ros time variable
class AtomicRosTime
{
private:
  std::mutex time_ops_mutex;
  ros::Time time;

public:
  void update(const ros::Time& t) {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    time = t;
  }

  ros::Time get() {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    return time;
  }
};

} // namespace ovc_embedded_driver

#endif
