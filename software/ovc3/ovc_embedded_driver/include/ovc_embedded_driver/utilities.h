#ifndef OVC_UTILITIES_H
#define OVC_UTILITIES_H

#include <mutex>

#include <ros/ros.h>

namespace ovc_embedded_driver {

// Class used for multithreaded access / update of ros time variable
class AtomicRosTime
{
  std::mutex time_mutex;

  ros::Time time; 

public:

  void update() { 
    std::lock_guard<std::mutex> lock(time_mutex);
    time = ros::Time::now();
  }

  ros::Time get() {
    std::lock_guard<std::mutex> lock(time_mutex);
    return time;
  }
};




} // namespace ovc_embedded_driver

#endif
