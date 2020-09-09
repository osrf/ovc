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
  ret_img = std::make_shared<OVCImage>();
  ret_img->image = cv::Mat(image_res.height() * 3 / 2, image_res.width(), CV_8UC1);
  ret_img->encoding = "yuv420";
  std::cout << "Argus init done" << std::endl;
}

static std::string gstreamerPipeline(int8_t cam_id, int8_t s_mode, int width,
                               int height, int8_t framerate,
                               int8_t flip_method) {
  // Disable digital gain
  return "nvarguscamerasrc sensor_id=" + std::to_string(cam_id) +
         " sensor_mode=" + std::to_string(s_mode) +
         " ! video/x-raw(memory:NVMM), width=(int)" + std::to_string(width) +
         ", height=(int)" + std::to_string(height) + ", format=(string)NV12, "
         "framerate=(fraction)" +
         std::to_string(framerate) + "/1 ! nvvidconv flip-method=" +
         std::to_string(flip_method) + " ! video/x-raw, format=(string)I420 ! appsink max-buffers=1 drop=True";
}

void Camera::initGstreamer(int sensor_id, int sensor_mode, int width, int height, int fps)
{
  // TODO don't hardcode resolution
  std::string pipeline = gstreamerPipeline(sensor_id, sensor_mode, width, height, fps, 0);
  std::cout << pipeline << std::endl;

  video_cap = std::make_unique<cv::VideoCapture>(pipeline, cv::CAP_GSTREAMER);
  if (!video_cap->isOpened())
  {
    std::cout << "Error opening video capture" << std::endl;
  }
  std::cout << "Gstreamer init done" << std::endl;
  ret_img = std::make_shared<OVCImage>();
  ret_img->encoding = "yuv420";
  //ret_img->image = cv::Mat(height * 3 / 2, width, CV_8UC1); 
}

std::shared_ptr<OVCImage> Camera::getGstreamerFrame()
{
  int capture_return = video_cap->read(ret_img->image);
  if (!capture_return)
    std::cout << "Capture failed" << std::endl;

  return ret_img;
}

std::shared_ptr<OVCImage> Camera::getArgusFrame()
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
  /*
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
  */

  // Fill ret_img
  ret_img->timestamp = frame_interface->getTime();
  ret_img->frame_id = frame_interface->getNumber();
  // TODO insert again
  memcpy(ret_img->image.data, (uint8_t *)image_interface->mapBuffer(),
      image_interface->getBufferSize());

  return ret_img;
}
