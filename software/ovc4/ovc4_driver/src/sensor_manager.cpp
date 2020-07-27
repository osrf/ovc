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
  // Create argus objects
  sm->camera_provider.reset(Argus::CameraProvider::create());
  auto camera_provider_interface = Argus::interface_cast<Argus::ICameraProvider>
    (sm->camera_provider);

  camera_provider_interface->getCameraDevices(&sm->camera_devices);
  std::cout << "Found " << sm->camera_devices.size() << " devices" << std::endl;

  Argus::UniqueObj<Argus::CaptureSession> capture_session(
      camera_provider_interface->createCaptureSession(sm->camera_devices[0]));

  sm->cameras[0]->initArgus(std::move(capture_session), sm->camera_devices[0], 0);

  return sm;
}

void SensorManager::probeImagers()
{
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
}

bool SensorManager::initCameras()
{
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    if (cameras[cam_id] == nullptr)
      continue;
    auto sensor_type = cameras[cam_id]->getType();
    cameras[cam_id]->setUioFile(cam_id);
    switch (sensor_type)
    {
      case sensor_type_t::PiCameraV2:
      {
        std::cout << "Picamera v2 detected for camera " << cam_id << std::endl;
        initCamera(cam_id, "1920x1080_30fps");
        break;
      }
      case sensor_type_t::PiCameraHQ:
      {
        std::cout << "Picamera HQ detected for camera " << cam_id << std::endl;
        initCamera(cam_id, "1920x1080_60fps");
        //initCamera(cam_id, "4032x3040_30fps");
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

void SensorManager::initCamera(int cam_id, const std::string& config_name)
{
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
  // And enable streaming
  usleep(5000);
  config_pkt = usb->initRegopPacket();
  cameras[cam_id]->enableStreaming(config_pkt.i2c[cam_id]);
  usb->sendAndPoll(config_pkt);
}

void SensorManager::updateExposure()
{
  auto exp_pkt = usb->initRegopPacket();
  // TODO implement sync in firmware
  //exp_pkt.packet_type = RX_PACKET_TYPE_I2C_SYNC;
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    if (cameras[cam_id] == nullptr)
      continue;
    cameras[cam_id]->updateExposure(exp_pkt.i2c[0]);
  }
  usb->sendPacket(exp_pkt);
  auto res_pkt = usb->pollData();
}

OVCImage SensorManager::getFrames()
{
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    if (cameras[cam_id] == nullptr)
      continue;
    return cameras[cam_id]->getFrame();
  }
  return {};
}
