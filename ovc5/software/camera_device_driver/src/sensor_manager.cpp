#include "ovc5_driver/sensor_manager.hpp"

#include <unistd.h>

#include <iostream>

#include "ovc5_driver/camera_modules.hpp"
#include "ovc5_driver/i2c_driver.h"

SensorManager::SensorManager(const std::vector<camera_config_t> &cams,
                             int line_counter_dev, int primary_cam)
    : line_counter(line_counter_dev), primary_cam_(primary_cam)
{
  // Configure the gpio chip.
  gpio = std::make_unique<GPIOChip>(GPIO_CHIP_NUMBER);

  int gpio_pin_num;
  // Turn on the cameras with the enable pins.
  for (camera_config_t cam : cams)
  {
    // This assumes that the enable pins are at EMIO addresses starting at zero
    // and the index matches the numbering of the vdma devices.
    gpio_pin_num = GPIO_EMIO_OFFSET + cam.id;
    gpio->openPin(gpio_pin_num, GPIO_OUTPUT);
    gpio->setValue(gpio_pin_num, true);
  }

  // Enables passing last line trigger from the selected mipi_csi2_rx_subsystem
  // to the line counter.
  gpio_pin_num = GPIO_SELECT_OFFSET + primary_cam;
  gpio->openPin(gpio_pin_num, GPIO_OUTPUT);
  gpio->setValue(gpio_pin_num, true);

  // Turn on user LED to signify that the sensors are on.
  gpio->openPin(GPIO_LED_PIN, GPIO_OUTPUT);
  gpio->setValue(GPIO_LED_PIN, true);

  // Open pin for triggering samples.
  gpio->openPin(GPIO_TRIG_PIN, GPIO_OUTPUT);
  gpio->setValue(GPIO_LED_PIN, false);

  // Sleep for a bit to allow cameras to boot up.
  usleep(100000);

  for (int index = 0; index < cams.size(); ++index)
  {
    camera_config_t cam = cams[index];
    int cam_id = cam.id;
    int vdma_dev = cam.vdma_dev;
    bool is_primary = primary_cam == cam_id;
    I2CDriver i2c(cam.i2c_dev);
    if (PiCameraV2::probe(i2c))
    {
      cameras.insert(
          {cam_id,
           std::make_unique<PiCameraV2>(i2c, vdma_dev, cam_id, is_primary)});
      continue;
    }
#if PROPRIETARY_SENSORS
    if (IMX490::probe(i2c))
    {
      cameras.insert(
          {cam_id,
           std::make_unique<IMX490>(i2c, vdma_dev, cam_id, is_primary)});
      continue;
    }
    if (AR0521::probe(i2c))
    {
      cameras.insert(
          {cam_id,
           std::make_unique<AR0521>(i2c, vdma_dev, cam_id, is_primary)});
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
  for (auto &[cam_id, camera] : cameras)
  {
    // Will initialize to default resolution and frame rate
    if (!camera->initialise())
    {
      std::cout << "Camera initialization failed" << std::endl;
      continue;
    }

    bool is_primary = cam_id == primary_cam_;
    if (is_primary)
      camera->setMain();
    else
      camera->setSecondary();
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

  // Trigger next frame immediately (circular buffer makes this okay).
  // The first frame will be available by the trigger in streamCameras.
  gpio->setValue(GPIO_TRIG_PIN, true);
  usleep(100);
  gpio->setValue(GPIO_TRIG_PIN, false);

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
