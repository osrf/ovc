#include <array>
#include <iostream>
#include <memory>
#include <signal.h>
#include <unistd.h>
#include <yaml-cpp/yaml.h>

#include <ovc5_driver/sensor_manager.hpp>
#include <ovc5_driver/timer_driver.hpp>

volatile sig_atomic_t stop = 0;

void inthandler(int signum) {
  std::cout << "Stopping" << std::endl;
  stop = 1;
}

struct config_t {
  std::array<int, NUM_CAMERAS> i2c_devs;
  std::array<int, NUM_CAMERAS> vdma_devs;
  int trigger_timer_dev;
  int line_count_timer_dev;
};

template <typename T> inline void store_to(T &value, YAML::Node node) {
  value = node.as<T>();
}

void load_config(config_t &config) {
  YAML::Node config_node = YAML::LoadFile("config.yaml");

  store_to(config.i2c_devs, config_node["i2c_devs"]);
  store_to(config.vdma_devs, config_node["vdma_devs"]);
  store_to(config.trigger_timer_dev, config_node["trigger_timer_dev"]);
  store_to(config.line_count_timer_dev, config_node["line_count_timer_dev"]);
}

int main(int argc, char **argv) {
  signal(SIGINT, inthandler);

  // Read in config variables
  config_t config;
  load_config(config);

  SensorManager sm(config.i2c_devs, config.vdma_devs,
                   config.line_count_timer_dev);
  Timer trigger_timer(config.trigger_timer_dev);

  // Hz, high time
  // trigger_timer.PWM(15.0, 0.0001);
  // trigger_timer.PWM(20.0, 0.001);

  if (argc > 1) {
    std::cout << "Resetting" << std::endl;
    return 0;
  }
  if (sm.getNumCameras() == 0) {
    std::cout << "No cameras detected" << std::endl;
    return 0;
  }
  while (!stop) {
    std::cout << "Waiting for frames" << std::endl;
    // sm.getFramesStereo();
    sm.sendFrames();
    sm.recvCommand();
  }
  return 0;
}
