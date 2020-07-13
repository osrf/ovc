#include <Argus/Argus.h>
#include <EGLStream/EGLStream.h>
#include <EGLStream/NV/ImageNativeBuffer.h>

#include <iostream>
#include <ovc4_driver/camera.hpp>

Camera::~Camera()
{
  auto capture_session_interface = Argus::interface_cast<Argus::ICaptureSession>(
      capture_session);

  capture_session_interface->stopRepeat();
  capture_session_interface->waitForIdle();
}

void Camera::initArgus(Argus::UniqueObj<Argus::CaptureSession> session,
    Argus::CameraDevice* camera_device, int sensor_mode)
{
  capture_session = std::move(session);
  auto capture_session_interface = Argus::interface_cast<Argus::ICaptureSession>(
      capture_session);

  auto device_properties = Argus::interface_cast<Argus::ICameraProperties>(
      camera_device);

  device_properties->getBasicSensorModes(&sensor_modes);

  auto sensor_mode_interface = Argus::interface_cast<Argus::ISensorMode>(
      sensor_modes[sensor_mode]);

  Argus::UniqueObj<Argus::OutputStreamSettings> output_stream_settings(
      capture_session_interface->createOutputStreamSettings(Argus::STREAM_TYPE_EGL));

  auto egl_stream_settings(Argus::interface_cast<Argus::IEGLOutputStreamSettings>(
      output_stream_settings));

  egl_stream_settings->setPixelFormat(Argus::PIXEL_FMT_YCbCr_420_888);
  //egl_stream_settings->setPixelFormat(Argus::PIXEL_FMT_RAW16);
  egl_stream_settings->setResolution(sensor_mode_interface->getResolution());
  egl_stream_settings->setMetadataEnable(true);

  output_stream.reset(
      capture_session_interface->createOutputStream(output_stream_settings.get()));
  consumer.reset(EGLStream::FrameConsumer::create(output_stream.get()));

  // TODO check intent
  request.reset(capture_session_interface->createRequest(
        Argus::CAPTURE_INTENT_PREVIEW));

  auto request_interface(Argus::interface_cast<Argus::IRequest>(request));
  Argus::Status status = request_interface->enableOutputStream(output_stream.get());

  // FINALLY ENABLE
  request_interface->enableOutputStream(output_stream.get());

  auto source_settings_interface = Argus::interface_cast<Argus::ISourceSettings>(request);
  source_settings_interface->setSensorMode(sensor_modes[0]);

  uint32_t request_id = capture_session_interface->repeat(request.get());

  // Initialise the return image
  auto image_res = sensor_mode_interface->getResolution();
  ret_img.buf = std::vector<uint8_t>(image_res.width() * image_res.height() * 4);
  ret_img.height = image_res.height();
  ret_img.width = image_res.width();
  ret_img.stride = 4 * image_res.width();
}

OVCImage Camera::getFrame()
{
  Argus::Status status;
  // TODO use status to report errors
  auto consumer_interface(Argus::interface_cast<EGLStream::IFrameConsumer>(consumer));
  std::cout << "Waiting for frame" << std::endl;
  Argus::UniqueObj<EGLStream::Frame> frame(
      consumer_interface->acquireFrame(Argus::TIMEOUT_INFINITE, &status));

  auto frame_interface(Argus::interface_cast<EGLStream::IFrame>(frame));
  auto image = frame_interface->getImage();

  auto image_interface(Argus::interface_cast<EGLStream::IImage>(image));
    
  auto image2d_interface(Argus::interface_cast<EGLStream::IImage2D>(image));
  auto img_size = image2d_interface->getSize();
  // This is potentially a bottleneck, copying to GPU
  auto native_buffer_interface = Argus::interface_cast<EGLStream::NV::IImageNativeBuffer>(image);
  int fd = native_buffer_interface->createNvBuffer(image2d_interface->getSize(),
      NvBufferColorFormat_ABGR32, NvBufferLayout_Pitch);
  // TODO Check if we can avoid one of the two copies
  void *pdata = NULL;
  NvBufferMemMap(fd, 0, NvBufferMem_Read, &pdata);
  NvBufferMemSyncForCpu(fd, 0, &pdata);

  // Fill ret_img
  ret_img.timestamp = frame_interface->getTime(),
  ret_img.frame_id = frame_interface->getNumber(),
  memcpy(&ret_img.buf[0], (uint8_t *)pdata, ret_img.buf.size());

  return ret_img;
}
