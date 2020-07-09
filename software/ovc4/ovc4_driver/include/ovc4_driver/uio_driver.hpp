
typedef uint32_t u32;
typedef int64_t s64;

// TODO make this a common include with kernel module
struct uio_map {
  u32 sensor_id;
  u32 test_val;
  s64 gain;
  s64 exposure;
  s64 frame_length;
  s64 exposure_short; // For HDR

};

class UIODriver
{
  int uio_file;

  uio_map *uio_mmap;

public:
  UIODriver(int num);

  uint32_t getSensorId() const;

  int64_t getGain() const;

  int64_t getExposure() const;

  int64_t getFrameLength() const;

  int64_t getExposureShort() const;
};

class UIOProber
{

};
