#include <signal.h>
#include <unistd.h>
#include <yaml-cpp/yaml.h>

#include <chrono>
#include <ctime>
#include <iostream>
#include <memory>
#include <string>
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
  std::vector<std::string> server_ips;
};

template <typename T>
inline void store_to(T &value, YAML::Node node)
{
  value = node.as<T>();
}

void load_config(config_t &config)
{
  YAML::Node config_node = YAML::LoadFile("config.yaml");

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
  for (auto ip : config_node["server_ips"])
  {
    config.server_ips.push_back(ip.as<std::string>());
  }
}

int main(int argc, char **argv)
{
  signal(SIGINT, inthandler);

  // Read in config variables
  config_t config;
  load_config(config);

  SensorManager sm(config.cams,
                   config.line_count_timer_dev,
                   config.trigger_timer_dev,
                   config.primary_cam,
                   config.server_ips);

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
  auto t0 = std::chrono::system_clock::now();
  while (!stop)
  {
    //std::cout << "Waiting for frames" << std::endl;
    sm.sendFrames();
    //sm.getFrames();
    auto t1 = std::chrono::system_clock::now();
    std::chrono::duration<double> diff = t1 - t0;
    std::cout << "dt = " << diff.count() << std::endl;
    t0 = t1;
    //sm.recvCommand();
  }
  return 0;
}
