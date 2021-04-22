#include <ovc5_driver/i2c_driver.h>
#include <unistd.h>

#include <iostream>
#include <ovc5_driver/camera_modules.hpp>
#include <ovc5_driver/sensor_manager.hpp>

SensorManager::SensorManager(const std::array<int, NUM_CAMERAS>& i2c_devs,
                             const std::array<int, NUM_CAMERAS>& vdma_devs,
                             int line_counter_dev)
    : line_counter(line_counter_dev)
{
  bool first_camera_found = false;
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    I2CDriver i2c(i2c_devs[cam_id]);
    if (PiCameraV2::probe(i2c))
    {
      cameras.insert(
          {cam_id, std::make_unique<PiCameraV2>(i2c, vdma_devs[cam_id], cam_id,
                                                !first_camera_found)});
      first_camera_found = true;
      continue;
    }
#if PROPRIETARY_SENSORS
    if (IMX490::probe(i2c))
    {
      cameras.insert(
          {cam_id, std::make_unique<IMX490>(i2c, vdma_devs[cam_id], cam_id,
                                            !first_camera_found)});
      first_camera_found = true;
      continue;
    }
    if (AR0521::probe(i2c))
    {
      cameras.insert(
          {cam_id, std::make_unique<AR0521>(i2c, vdma_devs[cam_id], cam_id,
                                            !first_camera_found)});
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
  for (auto& [cam_id, camera] : cameras)
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
  for (auto& [cam_id, camera] : cameras)
  {
    std::cout << "Enabling streaming" << std::endl;
    camera->enableStreaming();
  }
}

// The stereo only waits for a single interrupt from the first camera
std::map<int, unsigned char*> SensorManager::getFrames()
{
  std::map<int, unsigned char*> frame_map;
  // Start timer and wait for interrupt
  line_counter.interruptAtLine(LINE_BUFFER_SIZE);
  line_counter.waitInterrupt();
  auto cam_it = cameras.begin();
  while (cam_it != cameras.end())
  {
    frame_map.insert({cam_it->first, cam_it->second->getFrameNoInterrupt()});
    ++cam_it;
  }
  return frame_map;
}

void SensorManager::publishFrames()
{
  auto frames = getFrames();
  for (const auto& [cam_id, frame_ptr] : frames)
  {
    cameras[cam_id]->flushCache();
    pub.publish(frame_ptr, cameras[cam_id]->getCameraParams());
  }
}

int SensorManager::getNumCameras() const { return cameras.size(); }

SensorManager::~SensorManager()
{
  std::cout << "Resetting sensors" << std::endl;
  for (const auto& camera : cameras) camera.second->reset();
}
