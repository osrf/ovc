#ifndef ATOMIC_ROS_TIME_INC
#define ATOMIC_ROS_TIME_INC

#include <mutex>
#include <atomic>
#include <condition_variable>

#include <ros/ros.h>

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

  void update_no_notify(const ros::Time& t) {
    std::lock_guard<std::mutex> lock(time_ops_mutex);
    time = t;
  }

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

  ros::Time get_wait(uint8_t &last_timestamp_number)
  {
    // You might need to put a shared lock here,
    // but introducing additional readers might cause frames to start dropping.
    // But it hasn't caused issues so far so...
    while (last_timestamp_number == time_write_count)
    {
     time_condition_var.wait(time_guard);
    }
    last_timestamp_number = time_write_count;

    return time;
  }
};

#endif
