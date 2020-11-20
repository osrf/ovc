#include <memory>
#include <iostream>
#include <unistd.h>

#include <ovc5_driver/camera.hpp>
#include <ovc5_driver/vdma_driver.h>
#include <ovc5_driver/ethernet_driver.hpp>

static constexpr int I2C_DEV = 3;
static constexpr int VDMA_DEV = 5;

int main(int argc, char **argv)
{
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

  return 0;
}
