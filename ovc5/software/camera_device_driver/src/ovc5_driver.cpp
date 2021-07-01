#include <signal.h>
#include <unistd.h>
#include <yaml-cpp/yaml.h>

#include <iostream>
#include <memory>
#include <vector>

#include "ovc5_driver/sensor_manager.hpp"
#include "ovc5_driver/timer_driver.hpp"

volatile sig_atomic_t stop = 0;

void inthandler(int signum)
{
  std::cout << "Stopping" << std::endl;
  stop = 1;
}

struct config_t
{
  std::vector<camera_config_t> cams;
  int trigger_timer_dev;
  int line_count_timer_dev;
  int primary_cam;
};

template <typename T>
inline void store_to(T &value, YAML::Node node)
{
  value = node.as<T>();
}

void load_config(config_t &config)
{
  YAML::Node config_node = YAML::LoadFile("config.yaml");

  // store_to(config.cams, config_node["cams"]);
  for (auto cam : config_node["cams"])
  {
    camera_config_t cam_config;
    store_to(cam_config.id, cam["id"]);
    store_to(cam_config.i2c_dev, cam["i2c_dev"]);
    store_to(cam_config.vdma_dev, cam["vdma_dev"]);
    config.cams.push_back(cam_config);
  }
  store_to(config.trigger_timer_dev, config_node["trigger_timer_dev"]);
  store_to(config.line_count_timer_dev, config_node["line_count_timer_dev"]);
  store_to(config.primary_cam, config_node["primary_cam"]);
}

int main(int argc, char **argv)
{
  signal(SIGINT, inthandler);

  // Read in config variables
  config_t config;
  load_config(config);

  SensorManager sm(
      config.cams, config.line_count_timer_dev, config.primary_cam);
  Timer trigger_timer(config.trigger_timer_dev);

  // Hz, high time
  // trigger_timer.PWM(15.0, 0.0001);
  // trigger_timer.PWM(20.0, 0.001);

  if (argc > 1)
  {
    std::cout << "Resetting" << std::endl;
    return 0;
  }
  if (sm.getNumCameras() == 0)
  {
    std::cout << "No cameras detected" << std::endl;
    return 0;
  }
  while (!stop)
  {
    std::cout << "Waiting for frames" << std::endl;
    // sm.getFramesStereo();
    sm.sendFrames();
    sm.recvCommand();
  }
  return 0;
}
