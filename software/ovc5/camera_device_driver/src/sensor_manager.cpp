#include <iostream>
#include <unistd.h>

#include <ovc5_driver/camera.hpp>
#include <ovc5_driver/i2c_driver.h>
#include <ovc5_driver/sensor_manager.hpp>

SensorManager::SensorManager(const std::array<int, NUM_CAMERAS>& i2c_devs,
    const std::array<int, NUM_CAMERAS>& vdma_devs)
{
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    I2CDriver i2c(i2c_devs[cam_id]);
    if (PiCameraV2::probe(i2c))
      cameras.insert({cam_id, std::make_unique<PiCameraV2>(i2c, vdma_devs[cam_id])});
  }
  initCameras();
}

void SensorManager::initCameras()
{
  for (auto& [cam_id, camera] : cameras)
  {
    // Will initialize to default resolution and frame rate
    if (!camera->initialise())
    {
      std::cout << "Camera initialization failed" << std::endl;
      continue;
    }
    usleep(10000);
    std::cout << "Enabling streaming" << std::endl;
    camera->enableStreaming();
  }
}

std::map<int, unsigned char*> SensorManager::getFrames()
{
  std::map<int, unsigned char*> frame_map;
  for (const auto& [cam_id, camera] : cameras)
  {
    frame_map.insert({cam_id, camera->getFrame()});
  } 
  return frame_map;
}

void SensorManager::publishFrames()
{
  auto frames = getFrames();
  for (const auto& [cam_id, frame_ptr] : frames)
  {
    pub.publish(frame_ptr, cameras[cam_id]->getCameraParams());
  }
}

// Factory function
/*
std::unique_ptr<SensorManager> SensorManager::make()
{
  // TODO graceful exit if USB device is not found
  sm->usb = std::make_unique<USBDriver>();

  // Probe imagers
  sm->probeImagers();
  sm->initCameras();

  return sm;
  // Create argus objects
  sm->camera_provider.reset(Argus::CameraProvider::create());
  auto camera_provider_interface = Argus::interface_cast<Argus::ICameraProvider>
    (sm->camera_provider);

  camera_provider_interface->getCameraDevices(&sm->camera_devices);
  std::cout << "Found " << sm->camera_devices.size() << " devices" << std::endl;

  Argus::UniqueObj<Argus::CaptureSession> capture_session1(
      camera_provider_interface->createCaptureSession(sm->camera_devices[0]));
  Argus::UniqueObj<Argus::CaptureSession> capture_session2(
      camera_provider_interface->createCaptureSession(sm->camera_devices[1]));

  sm->cameras[0]->initArgus(std::move(capture_session1), sm->camera_devices[0], 0);
  sm->cameras[1]->initArgus(std::move(capture_session2), sm->camera_devices[1], 0);

  return sm;
}

void SensorManager::probeImagers()
{
  // Enable all the imagers first
  usb->setImagersEnable(true);
  sleep(1);
  // TODO iterate through imager types
  auto probe_pkt = usb->initRegopPacket();
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    PiCameraV2::fillProbePkt(probe_pkt.i2c[cam_id]);
  }
  // TODO handle timeouts
  auto res_pkt = usb->sendAndPoll(probe_pkt);
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    if (PiCameraV2::checkProbePkt(res_pkt->i2c[cam_id]))
    {
      cameras[cam_id] = std::make_unique<PiCameraV2>();
    }
  }
  // TODO remove duplicated code
  probe_pkt = usb->initRegopPacket();
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    PiCameraHQ::fillProbePkt(probe_pkt.i2c[cam_id]);
  }
  // TODO handle timeouts
  res_pkt = usb->sendAndPoll(probe_pkt);
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    if (PiCameraHQ::checkProbePkt(res_pkt->i2c[cam_id]))
    {
      cameras[cam_id] = std::make_unique<PiCameraHQ>();
    }
  }
#if PROPRIETARY_SENSORS
  // TODO remove duplicated code
  probe_pkt = usb->initRegopPacket();
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    AR0521::fillProbePkt(probe_pkt.i2c[cam_id]);
  }
  // TODO handle timeouts
  res_pkt = usb->sendAndPoll(probe_pkt);
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    if (AR0521::checkProbePkt(res_pkt->i2c[cam_id]))
    {
      cameras[cam_id] = std::make_unique<AR0521>();
    }
  }
#endif
}

bool SensorManager::initCameras()
{
  for (auto& camera : cameras)
  {
    camera.second->setUioFile(camera.first);
    switch (camera.second->getType())
    {
      case sensor_type_t::PiCameraV2:
      {
        std::cout << "Picamera v2 detected for camera " << camera.first << std::endl;
        initCamera(camera.first, 0, 1920, 1080, 30);
        break;
      }
      case sensor_type_t::PiCameraHQ:
      {
        std::cout << "Picamera HQ detected for camera " << camera.first << std::endl;
        initCamera(camera.first, 1, 1920, 1080, 60);
        break;
      }
      case sensor_type_t::AR0521:
      {
        std::cout << "AR0521 sensor detected for camera " << camera.first << std::endl;
        // TODO find a way to make multiple sensors work
        initCamera(camera.first, 0, 2592, 1944, 15);
        break;
      }
      default:
      {
        std::cout << "Camera not recognized" << std::endl;
      }
    }
  }
  return true;
}

void SensorManager::updateExposure(int main_camera_id) const
{
  auto exp_pkt = usb->initRegopPacket();
  // Exposure I2C operations happen simultaneously
  exp_pkt.packet_type = RX_PACKET_TYPE_I2C_SYNC;
  // The main camera sets the exposure, all the other cameras have the same
  cameras.at(main_camera_id)->updateExposure(exp_pkt.i2c[main_camera_id]);
  for (const auto& camera : cameras)
  {
    exp_pkt.i2c[camera.first] = exp_pkt.i2c[main_camera_id];
  }
  usb->sendPacket(exp_pkt);
  auto res_pkt = usb->pollData();
}

std::shared_ptr<OVCImage> SensorManager::getFrame(int cam_id) const
{
  return cameras.at(cam_id)->getGstreamerFrame();
}

std::vector<int> SensorManager::getProbedCameraIds() const
{
  std::vector<int> camera_ids;
  for (const auto& camera : cameras)
    camera_ids.push_back(camera.first);
  return camera_ids;
}

SensorManager::~SensorManager()
{
  std::cout << "Resetting sensors" << std::endl;
  auto config_pkt = usb->initRegopPacket();
  for (const auto& camera : cameras)
    camera.second->reset(config_pkt.i2c[camera.first]);
  usb->sendAndPoll(config_pkt);
  // Not shutdown all the imagers
  usb->setImagersEnable(false);
}
*/
