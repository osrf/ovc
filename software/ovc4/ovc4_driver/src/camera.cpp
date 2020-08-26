#include <Argus/Argus.h>
#include <EGLStream/EGLStream.h>
#include <EGLStream/NV/ImageNativeBuffer.h>

#include <opencv2/opencv.hpp>

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

  device_properties->getAllSensorModes(&sensor_modes);
  std::cout << "Found " << sensor_modes.size() << " modes" << std::endl;

  auto sensor_mode_interface = Argus::interface_cast<Argus::ISensorMode>(
      sensor_modes[sensor_mode]);

  Argus::UniqueObj<Argus::OutputStreamSettings> output_stream_settings(
      capture_session_interface->createOutputStreamSettings(Argus::STREAM_TYPE_EGL));

  auto egl_stream_settings(Argus::interface_cast<Argus::IEGLOutputStreamSettings>(
      output_stream_settings));

  auto image_res = sensor_mode_interface->getResolution();

  egl_stream_settings->setPixelFormat(Argus::PIXEL_FMT_YCbCr_420_888);
  //egl_stream_settings->setPixelFormat(Argus::PIXEL_FMT_RAW16);
  egl_stream_settings->setResolution(image_res);
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
  ret_img.buf = std::vector<uint8_t>(image_res.width() * image_res.height() * 4);
  ret_img.height = image_res.height();
  ret_img.width = image_res.width();
  ret_img.stride = 4 * image_res.width();
}

static std::string gstreamer_pipeline(int8_t cam_id, int8_t s_mode, int display_width,
                               int display_height, int8_t framerate,
                               int8_t flip_method, std::string outputFormat) {
  // Disable digital gain
  return "nvarguscamerasrc sensor_id=" + std::to_string(cam_id) +
         " sensor_mode=" + std::to_string(s_mode) +
         " ispdigitalgainrange=\"1 1\" awblock=1 wbmode=0" + 
         " ! video/x-raw(memory:NVMM), format=(string)NV12, "
         "framerate=(fraction)" +
         std::to_string(framerate) + "/1 ! nvvidconv flip-method=" +
         std::to_string(flip_method) + " ! video/x-raw, width=(int)" +
         std::to_string(display_width) + ", height=(int)" +
         std::to_string(display_height) +
         ", format=(string)BGRx ! videoconvert ! video/x-raw, format=(string)" +
         outputFormat + " ! appsink";
}


void Camera::initGstreamer()
{
  // TODO don't hardcode resolution
  std::string pipeline = gstreamer_pipeline(0, 0, 2592, 1944, 30, 0, std::string("BGR"));

  video_cap = std::make_unique<cv::VideoCapture>(pipeline, cv::CAP_GSTREAMER);
  if (!video_cap->isOpened())
  {
    std::cout << "Error opening video capture" << std::endl;
  }
  std::cout << "Gstreamer init done" << std::endl;
  ret_img.buf = std::vector<uint8_t>(2592 * 1944 * 3);
  ret_img.height = 1944;
  ret_img.width = 2592;
  ret_img.stride = 3 * 2592;
  
}

OVCImage Camera::getGstreamerFrame()
{
  cv::Mat img;
  std::cout << "Waiting for frame" << std::endl;
  int capture_return = video_cap->read(img);
  if (!capture_return)
    std::cout << "Capture failed" << std::endl;

  memcpy(&ret_img.buf[0], img.data, ret_img.buf.size());
  return ret_img;
}

OVCImage Camera::getArgusFrame()
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
  // Only create buffer if it was not allocated previously
  if (nvbuffer_fd == -1)
  {
    nvbuffer_fd = native_buffer_interface->createNvBuffer(image2d_interface->getSize(),
        NvBufferColorFormat_ABGR32, NvBufferLayout_Pitch);
  }
  else
  {
    // TODO we can rotate here
    native_buffer_interface->copyToNvBuffer(nvbuffer_fd);
  }
  // TODO Check if we can avoid one of the two copies
  void *pdata = NULL;
  NvBufferMemMap(nvbuffer_fd, 0, NvBufferMem_Read, &pdata);
  NvBufferMemSyncForCpu(nvbuffer_fd, 0, &pdata);

  // Fill ret_img
  ret_img.timestamp = frame_interface->getTime(),
  ret_img.frame_id = frame_interface->getNumber(),
  memcpy(&ret_img.buf[0], (uint8_t *)pdata, ret_img.buf.size());

  return ret_img;
}
