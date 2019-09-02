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

  std::condition_variable time_condition_var;
  std::mutex time_guard_mutex;
  std::unique_lock<std::mutex> time_guard;

public:
  AtomicRosTime()
  : time_guard(time_guard_mutex)
  , time_write_count(0)
  {}

  // These variables are public to save on function call overhead
  std::atomic<uint8_t> time_write_count;

  void update(const ros::Time& t) {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    time = t;

    time_write_count += 1;
    time_condition_var.notify_all();
  }

  ros::Time get() {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    return time;
  }

  ros::Time get_wait(const uint8_t last_timestamp_number)
  {
    while (last_timestamp_number == time_write_count)
    {
       time_condition_var.wait(time_guard);
    }

    return time;
  }
};

} // namespace ovc_embedded_driver

#endif
