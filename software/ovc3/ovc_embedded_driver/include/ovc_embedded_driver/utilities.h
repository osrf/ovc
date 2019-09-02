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
  // These variables are public to save on function call overhead
  std::atomic<uint8_t> time_read_count;
  std::atomic<uint8_t> time_write_count;

  AtomicRosTime() : time_read_count(0), time_write_count(0) {}

  void update(const ros::Time& t) {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    time = t;
  }

  ros::Time get() {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    return time;
  }

  // Getters and setters
  void increment_read_count() { time_read_count += 1; }
  void increment_write_count() { time_write_count += 1; }
  void reset_read_count() { time_read_count = 0; }
  void reset_write_count() { time_write_count = 0; }

  uint8_t get_read_count() { return time_read_count.load(); }
  uint8_t get_write_count() { return time_write_count.load(); }
};

} // namespace ovc_embedded_driver

#endif
