#include <Argus/Argus.h>
#include <EGLStream/EGLStream.h>

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

  // TODO check if EGL is ok
  Argus::UniqueObj<Argus::OutputStreamSettings> output_stream_settings(
      capture_session_interface->createOutputStreamSettings(Argus::STREAM_TYPE_EGL));

  auto egl_stream_settings(Argus::interface_cast<Argus::IEGLOutputStreamSettings>(
      output_stream_settings));

  // TODO is this ok?
  //egl_stream_settings->setPixelFormat(Argus::PIXEL_FMT_YCbCr_420_888);
  egl_stream_settings->setPixelFormat(Argus::PIXEL_FMT_RAW16);
  egl_stream_settings->setResolution(sensor_mode_interface->getResolution());
  egl_stream_settings->setMetadataEnable(true);

  output_stream.reset(
      capture_session_interface->createOutputStream(output_stream_settings.get()));
  consumer.reset(EGLStream::FrameConsumer::create(output_stream.get()));

  // TODO check intent
  request.reset(capture_session_interface->createRequest(
        Argus::CAPTURE_INTENT_VIDEO_RECORD));

  auto request_interface(Argus::interface_cast<Argus::IRequest>(request));
  Argus::Status status = request_interface->enableOutputStream(output_stream.get());

  // FINALLY ENABLE
  request_interface->enableOutputStream(output_stream.get());

  auto source_settings_interface = Argus::interface_cast<Argus::ISourceSettings>(request);
  source_settings_interface->setSensorMode(sensor_modes[0]);

  uint32_t request_id = capture_session_interface->repeat(request.get());
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
  // Get buffer count
  std::cout << "Image ID is " << frame_interface->getNumber() << " ts = " << frame_interface->getTime() << std::endl;
  std::cout << "Image buffer count = " << image_interface->getBufferCount() << std::endl;
  std::cout << "Image buffer size = " << image_interface->getBufferSize() << std::endl;
  std::cout << "Image size = " << img_size.width() << "," << img_size.height() << std::endl;
  OVCImage img = {
    .buf = image_interface->mapBuffer(0, &status),
    .buf_size = image_interface->getBufferSize(0),
    .height = img_size.height(),
    .width = img_size.width(),
    .timestamp = frame_interface->getTime(),
    .frame_id = frame_interface->getNumber(),
    .stride = image2d_interface->getStride()
  };

  return img;
  //return {image_interface->mapBuffer(0, &status), image_interface->getBufferSize(0)};
}
