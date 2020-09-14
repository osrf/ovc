#include <Argus/Argus.h>
#include <EGLStream/EGLStream.h>
#include <EGLStream/NV/ImageNativeBuffer.h>

#include <opencv2/opencv.hpp>

#include <boost/align/aligned_allocator.hpp>

#include <malloc.h>
#include <linux/ioctl.h>
#include <linux/types.h>
#include <linux/v4l2-common.h>
#include <linux/v4l2-controls.h>
#include <linux/videodev2.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>

#include <iostream>
#include <ovc4_driver/camera.hpp>

constexpr int IMAGE_ALIGNMENT_SIZE = 16;

template <typename T>
using aligned_vector = std::vector<T, boost::alignment::aligned_allocator<T, IMAGE_ALIGNMENT_SIZE>>;

template <class T>
void wrapArrayInVector( T *sourceArray, size_t arraySize, std::vector<T, std::allocator<T> > &targetVector ) {
  typename std::_Vector_base<T, std::allocator<T> >::_Vector_impl *vectorPtr =
    (typename std::_Vector_base<T, std::allocator<T> >::_Vector_impl *)((void *) &targetVector);
  vectorPtr->_M_start = sourceArray;
  vectorPtr->_M_finish = vectorPtr->_M_end_of_storage = vectorPtr->_M_start + arraySize;
}

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
         " sensor_mode=" + std::to_string(s_mode) + " wbmode=0 awblock=1" +
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

void Camera::initV4L(int sensor_id, int width, int height)
{
  // Aligned memory allocation, then assign to CV Mat
  unsigned int page_size = getpagesize();
  size_t buffer_size = (width * height * 2 + page_size - 1) & ~(page_size - 1);
  unsigned char* img_buf = (unsigned char*)memalign(page_size, buffer_size);

  //ret_img = std::make_shared<OVCImage>();
  //ret_img->image = cv::Mat(height, width, CV_16UC1, img_buf);
  //ret_img->encoding = "bayer_grbg16";

  std::string v4l_filename = "/dev/video" + std::to_string(sensor_id);
  v4l_fd = open(v4l_filename.c_str(), O_RDWR);
  if(v4l_fd < 0){
    perror("Failed to open device, OPEN");
    return;
  }


  // 2. Ask the device if it can capture frames
  v4l2_capability capability;
  if(ioctl(v4l_fd, VIDIOC_QUERYCAP, &capability) < 0){
      // something went wrong... exit
      perror("Failed to get device capabilities, VIDIOC_QUERYCAP");
      return;
  }


  // 3. Set Image format
  v4l2_format imageFormat;
  imageFormat.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  imageFormat.fmt.pix.width = width;
  imageFormat.fmt.pix.height = height;
  imageFormat.fmt.pix.bytesperline = 2 * width;
  imageFormat.fmt.pix.pixelformat = V4L2_PIX_FMT_SGRBG16;
  imageFormat.fmt.pix.field = V4L2_FIELD_NONE;
  // tell the device you are using this format
  if(ioctl(v4l_fd, VIDIOC_S_FMT, &imageFormat) < 0){
      perror("Device could not set format, VIDIOC_S_FMT");
      return;
  }


  // 4. Request Buffers from the device
  v4l2_requestbuffers requestBuffer = {0};
  requestBuffer.count = 1; // one request buffer
  requestBuffer.type = V4L2_BUF_TYPE_VIDEO_CAPTURE; // request a buffer wich we an use for capturing frames
  requestBuffer.memory = V4L2_MEMORY_USERPTR;

  if(ioctl(v4l_fd, VIDIOC_REQBUFS, &requestBuffer) < 0){
      perror("Could not request buffer from device, VIDIOC_REQBUFS");
      return;
  }


  // 5. Quety the buffer to get raw data ie. ask for the you requested buffer
  // and allocate memory for it
  /*
  v4l2_buffer queryBuffer = {0};
  queryBuffer.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  queryBuffer.memory = V4L2_MEMORY_USERPTR;
  queryBuffer.m.userptr = (size_t)ret_img->image.data;
  queryBuffer.length = 1944*2592*2;
  queryBuffer.index = 0;
  if(ioctl(v4l_fd, VIDIOC_QUERYBUF, &queryBuffer) < 0){
      perror("Device did not return the buffer information, VIDIOC_QUERYBUF");
      return;
  }
  // use a pointer to point to the newly created buffer
  // mmap() will map the memory address of the device to
  // an address in memory
  std::cout << "Query buffer length is " << queryBuffer.length << std::endl;
  //v4l_buffer = (char*)mmap(NULL, queryBuffer.length, PROT_READ | PROT_WRITE, MAP_SHARED,
  //                    v4l_fd, queryBuffer.m.offset);
  //memset(v4l_buffer, 0, queryBuffer.length);
  */


  // 6. Get a frame
  // Create a new buffer type so the device knows whichbuffer we are talking about
  //static unsigned char test[1944*2592*2];
  wrapArrayInVector(img_buf, 1944*2592*2, img_msg.data);
  //img_msg.data = std::move(aligned_vector<unsigned char>(1944*2592*2));

  img_msg.height = height;
  img_msg.width = width;
  img_msg.step = 2 * width;
  img_msg.encoding = "bayer_grbg16";
  memset(&bufferinfo, 0, sizeof(bufferinfo));
  bufferinfo.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
  bufferinfo.memory = V4L2_MEMORY_USERPTR;
  //bufferinfo.m.userptr = (uint64_t)ret_img->image.data;
  bufferinfo.m.userptr = (uint64_t)img_msg.data.data();
  bufferinfo.length = 1944*2592*2;

  // Activate streaming
  int type = bufferinfo.type;
  if(ioctl(v4l_fd, VIDIOC_STREAMON, &type) < 0){
      perror("Could not start streaming, VIDIOC_STREAMON");
      return;
  }

  if(ioctl(v4l_fd, VIDIOC_QBUF, &bufferinfo) < 0){
      perror("Could not queue buffer, VIDIOC_QBUF");
  }

  std::cout << "V4L initialized correctly" << std::endl;
}

sensor_msgs::Image& Camera::getV4LFrame()
{
  // Queue the buffer

  // Dequeue the buffer
  if(ioctl(v4l_fd, VIDIOC_DQBUF, &bufferinfo) < 0){
      perror("Could not dequeue the buffer, VIDIOC_DQBUF");
  }

  if(ioctl(v4l_fd, VIDIOC_QBUF, &bufferinfo) < 0){
      perror("Could not queue buffer, VIDIOC_QBUF");
  }
  // Frames get written after dequeuing the buffer

  // Copy
  //memcpy(ret_img->image.data, v4l_buffer, 1944*2592*2);
  //memcpy(&img_msg.data[0], v4l_buffer, 1944*2592*2);

  // Write the data out to file
  /*
  ofstream outFile;
  outFile.open("output.raw", ios::binary| ios::app);
  outFile.write(buffer, (double)bufferinfo.bytesused);

  // Close the file
  outFile.close();
  */
  return img_msg;

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
