// TODO remove ros dependency (only used for logging)
#include <ros/ros.h>
#include <Argus/Argus.h>
#include <EGLStream/EGLStream.h>

#include <ovc4_driver/sensor_manager.hpp>


// Factory function
std::unique_ptr<SensorManager> SensorManager::make()
{
  std::unique_ptr<SensorManager> sm(new SensorManager);
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

void SensorManager::initCamera(int cam_id, int sensor_mode, int width, int height, int fps)
{
  std::string config_name = std::to_string(width) + "x" + std::to_string(height) +
    "_" + std::to_string(fps) + "fps";
  // TODO check all the result packets
  bool done = false;
  // Start with a reset
  auto config_pkt = usb->initRegopPacket();
  cameras[cam_id]->reset(config_pkt.i2c[cam_id]);
  usb->sendAndPoll(config_pkt);
  usleep(5000);
  // All the configuration packets
  do
  {
    config_pkt = usb->initRegopPacket();
    auto res = cameras[cam_id]->initialise(config_name, config_pkt.i2c[cam_id]);
    usb->sendAndPoll(config_pkt);
    done = (res == camera_init_ret_t::DONE);
  }
  while (!done);
  // Set the extra GPIO function
  usb_rx_packet_t gpio_cfg = {0};
  gpio_cfg.packet_type = RX_PACKET_TYPE_GPIO_CFG;
  // GPIO 0 is enable, GPIO 1 is free for use
  cameras[cam_id]->setGPIO(gpio_cfg.gpio[cam_id][1]);
  usb->sendAndPoll(gpio_cfg);
  // And enable streaming
  usleep(5000);
  config_pkt = usb->initRegopPacket();
  cameras[cam_id]->enableStreaming(config_pkt.i2c[cam_id]);
  usb->sendAndPoll(config_pkt);
  // Now initialise the camera capture
  cameras[cam_id]->initGstreamer(cam_id, sensor_mode, width, height, fps);
}

void SensorManager::updateExposure(int main_camera_id) const
{
  auto exp_pkt = usb->initRegopPacket();
  // TODO implement sync in firmware
  //exp_pkt.packet_type = RX_PACKET_TYPE_I2C_SYNC;
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
