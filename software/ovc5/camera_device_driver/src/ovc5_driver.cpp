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

static constexpr int TIMER_DEV = 0;

volatile sig_atomic_t stop;

void inthandler(int signum) {
  std::cout << "Stopping" << std::endl;
  stop = 1;
}

int main(int argc, char **argv)
{
  //signal(SIGINT, inthandler);
  SensorManager sm(I2C_DEVS, VDMA_DEVS);
  TimerDriver timer(TIMER_DEV);

  // Hz, high time
  timer.start(30.0, 0.001);

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
    //sm.getFrames();
    sm.publishFrames();
  }
  /*
  std::unique_ptr<I2CDriver> i2c = std::make_unique<I2CDriver>(I2C_DEV);
  std::unique_ptr<I2CCamera> camera;
  if (PiCameraV2::probe(i2c.get()))
  {
    // Pi camera found
    camera = std::make_unique<PiCameraV2>(std::move(i2c));
    //camera->reset();
    //return 0;
    camera->initialise("1920x1080_30fps");
    //return 0;
    VDMADriver vdma(VDMA_DEV);
    usleep(10000);
    camera->enableStreaming();
    //return 0;
    // TODO VDMA init and image streaming
    std::cout << "Initializing driver" << std::endl;
    // Publish once in a while, TODO get raw pointer from vdma driver
    EthernetPublisher eth;
    std::cout << "Connected" << std::endl;
    while (true)
    {
      // Get frames
      auto imageptr = vdma.getImage();
      std::cout << "Got image with first pixel bytes " << (int)imageptr[0] << (int)imageptr[1] << std::endl;
      eth.publish(imageptr);

    }
  }
  */

  return 0;
}
