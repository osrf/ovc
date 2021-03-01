#include <memory>
#include <array>
#include <iostream>
#include <unistd.h>
#include <signal.h>

#include <ovc5_driver/sensor_manager.hpp>
#include <ovc5_driver/timer_driver.hpp>

#define NUM_CAMERAS 2
static constexpr std::array<int, NUM_CAMERAS> I2C_DEVS = {2, 3};
static constexpr std::array<int, NUM_CAMERAS> VDMA_DEVS = {2, 1};

static constexpr int TRIGGER_TIMER_DEV = 0;
static constexpr int LINE_COUNT_TIMER_DEV = 3;

volatile sig_atomic_t stop;

void inthandler(int signum) {
  std::cout << "Stopping" << std::endl;
  stop = 1;
}

int main(int argc, char **argv)
{
  signal(SIGINT, inthandler);
  SensorManager sm(I2C_DEVS, VDMA_DEVS, LINE_COUNT_TIMER_DEV);
  Timer trigger_timer(TRIGGER_TIMER_DEV);

  // Hz, high time
  //trigger_timer.PWM(15.0, 0.0001);
  //trigger_timer.PWM(20.0, 0.001);

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
    //sm.getFramesStereo();
    sm.publishFrames();
  }
  return 0;
}
