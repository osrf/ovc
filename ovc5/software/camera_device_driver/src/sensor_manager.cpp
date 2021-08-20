#include "ovc5_driver/sensor_manager.hpp"

#include <unistd.h>

#include <iostream>

#include "ovc5_driver/camera_modules.hpp"
#include "ovc5_driver/i2c_driver.h"

SensorManager::SensorManager(const std::vector<camera_config_t> &cams,
                             int line_counter_dev, int trigger_timer_dev,
                             int primary_cam,
                             std::vector<std::string> server_ips)
    : line_counter(line_counter_dev),
      trigger_timer(trigger_timer_dev),
      primary_cam_(primary_cam)
{
  // Configure the ethernet client.
  client = std::make_unique<EthernetClient>(server_ips);
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

  // Set up trigger timer at the configured frequency.
  trigger_timer.PWM(DEFAULT_FRAME_RATE, 0.001);

  // Sleep for a bit to allow cameras to boot up.
  usleep(100000);

  for (int index = 0; index < cams.size(); ++index)
  {
    camera_config_t cam = cams[index];
    int cam_id = cam.id;
    int vdma_dev = cam.vdma_dev;
    bool is_primary = primary_cam == cam_id;
    I2CDriver i2c(cam.i2c_dev);
    for (auto cam_module : CAMERA_MODULES)
    {
      if (cam_module.probe(i2c))
      {
        cameras.insert(
            {cam_id,
             cam_module.constructor(i2c, vdma_dev, cam_id, is_primary)});
        break;
      }
    }
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
    client->send(frame_ptr, cameras[cam_id]->getCameraParams());
  }
}

/* JSON Format
 *
 * {
 *  "fps": float   Global capture trigger.
 *  "cameras": [
 *    {
 *      "id": int (Required for all data in this field)
 *      "exposure": float
 *    }
 *  ]
 * }
 *
 * The json message is parsed in an optional fashion to let the user configure
 * whatever they want to without changing other settings.
 */
void SensorManager::recvCommand()
{
  auto node = client->recv_json();
  if (nullptr == node)
  {
    return;
  }
  auto frame_rate = node->get("frame_rate", Json::Value::null);
  if (Json::Value::null != frame_rate)
  {
    trigger_timer.PWM(frame_rate.asFloat(), 0.001);
  }

  auto camera_node = node->get("cameras", Json::Value::null);
  if (Json::Value::null != camera_node)
  {
    for (auto cam : camera_node)
    {
      auto id_node = cam["id"];
      if (Json::Value::null == id_node)
      {
        std::cout << "Received command for camera without an id. Unable to "
                     "apply settings."
                  << std::endl;
        continue;
      }

      int id = id_node.asInt();
      if (0 == cameras.count(id))
      {
        std::cout << "Received command for camera " << id
                  << " which is not initialized." << std::endl;
        continue;
      }

      auto exposure_node = cam["exposure"];
      if (Json::Value::null != exposure_node &&
          cameras[id]->getCameraParams().dynamic_configs.exposure)
      {
        cameras[id]->updateExposure(exposure_node.asFloat());
        std::cout << "Updated cam " << id << "'s exposure to "
                  << exposure_node.asFloat() << std::endl;
      }
    }
  }
}

int SensorManager::getNumCameras() const { return cameras.size(); }

SensorManager::~SensorManager()
{
  std::cout << "Resetting sensors" << std::endl;
  for (const auto &camera : cameras) camera.second->reset();
}
