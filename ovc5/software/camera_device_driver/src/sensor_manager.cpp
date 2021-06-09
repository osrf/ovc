#include "ovc5_driver/sensor_manager.hpp"

#include <unistd.h>

#include <iostream>

#include "ovc5_driver/camera_modules.hpp"
#include "ovc5_driver/i2c_driver.h"

SensorManager::SensorManager(const std::array<int, NUM_CAMERAS> &i2c_devs,
                             const std::array<int, NUM_CAMERAS> &vdma_devs,
                             int line_counter_dev)
    : line_counter(line_counter_dev)
{
  // Configure the gpio chip.
  gpio = std::make_unique<GPIOChip>(GPIO_CHIP_NUMBER);

  int gpio_pin_num;
  // Turn on the cameras with the enable pins.
  for (int vdma_dev : vdma_devs)
  {
    // This assumes that the enable pins are at EMIO addresses starting at zero
    // and the index matches the numbering of the vdma devices.
    gpio_pin_num = GPIO_EMIO_OFFSET + vdma_dev;
    gpio->openPin(gpio_pin_num, GPIO_OUTPUT);
    gpio->setValue(gpio_pin_num, true);
  }

  // Turn on user GPIO to signify that the sensors are on.
  gpio->openPin(GPIO_LED_PIN, GPIO_OUTPUT);
  gpio->setValue(GPIO_LED_PIN, true);

  // Open pin for triggering samples.
  gpio->openPin(GPIO_TRIG_PIN, GPIO_OUTPUT);

  // Sleep for a bit to allow cameras to boot up.
  usleep(100000);

  bool first_camera_found = false;
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    I2CDriver i2c(i2c_devs[cam_id]);
    if (PiCameraV2::probe(i2c))
    {
      cameras.insert(
          {cam_id,
           std::make_unique<PiCameraV2>(
               i2c, vdma_devs[cam_id], cam_id, !first_camera_found)});
      first_camera_found = true;
      continue;
    }
#if PROPRIETARY_SENSORS
    if (IMX490::probe(i2c))
    {
      cameras.insert(
          {cam_id,
           std::make_unique<IMX490>(
               i2c, vdma_devs[cam_id], cam_id, !first_camera_found)});
      first_camera_found = true;
      continue;
    }
    if (AR0521::probe(i2c))
    {
      cameras.insert(
          {cam_id,
           std::make_unique<AR0521>(
               i2c, vdma_devs[cam_id], cam_id, !first_camera_found)});
      first_camera_found = true;
      continue;
    }
#endif
  }
  initCameras();
  usleep(10000);
  streamCameras();
}

void SensorManager::initCameras()
{
  bool first_cam_found = false;
  for (auto &[cam_id, camera] : cameras)
  {
    // Will initialize to default resolution and frame rate
    if (!camera->initialise())
    {
      std::cout << "Camera initialization failed" << std::endl;
      continue;
    }
    if (!first_cam_found)
      camera->setMain();
    else
      camera->setSecondary();
    first_cam_found = true;
  }
}

void SensorManager::streamCameras()
{
  for (auto &[cam_id, camera] : cameras)
  {
    std::cout << "Enabling streaming" << std::endl;
    camera->enableStreaming();
  }
  // Trigger a sampling event to read in the first frame.
  gpio->setValue(GPIO_TRIG_PIN, true);
  usleep(100);
  gpio->setValue(GPIO_TRIG_PIN, false);
}

// The stereo only waits for a single interrupt from the first camera
std::map<int, unsigned char *> SensorManager::getFrames()
{
  std::map<int, unsigned char *> frame_map;
  // Start timer and wait for interrupt
  line_counter.interruptAtLine(LINE_BUFFER_SIZE);
  if (!line_counter.waitInterrupt())
  {
    return frame_map;
  }
  auto cam_it = cameras.begin();
  while (cam_it != cameras.end())
  {
    frame_map.insert({cam_it->first, cam_it->second->getFrameNoInterrupt()});
    ++cam_it;
  }

  // Trigger next frame after reading in current frame. The first frame will be
  // available by the trigger in streamCameras.
  gpio->setValue(GPIO_TRIG_PIN, true);
  usleep(100);
  gpio->setValue(GPIO_TRIG_PIN, false);

  return frame_map;
}

void SensorManager::sendFrames()
{
  auto frames = getFrames();
  for (const auto &[cam_id, frame_ptr] : frames)
  {
    cameras[cam_id]->flushCache();
    client.send(frame_ptr, cameras[cam_id]->getCameraParams());
  }
}

void SensorManager::recvCommand()
{
  auto pkt = client.recv();
  if (nullptr == pkt)
  {
    return;
  }
  if (RX_PACKET_TYPE_CMD_CONFIG == pkt->packet_type)
  {
    std::cout << "Received config packet with {exposure: "
              << pkt->config.exposure << "}" << std::endl;
  }
}

int SensorManager::getNumCameras() const { return cameras.size(); }

SensorManager::~SensorManager()
{
  std::cout << "Resetting sensors" << std::endl;
  for (const auto &camera : cameras) camera.second->reset();
}
