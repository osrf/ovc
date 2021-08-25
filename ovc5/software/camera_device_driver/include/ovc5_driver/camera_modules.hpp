#ifndef CAMERA_MODULES_INC
#define CAMERA_MODULES_INC

#include <memory>

#include "ovc5_driver/camera.hpp"

// Append all the camera headers here
#include "ovc5_driver/cameras/picam_v2.hpp"
//#include <ovc4_driver/cameras/picam_hq.hpp>
#ifdef PROPRIETARY_SENSORS
#include "ovc5_driver/cameras/ar0234.hpp"
#include "ovc5_driver/cameras/ar0521.hpp"
#include "ovc5_driver/cameras/imx490.hpp"
#endif

#define CAM_CONSTRUCTOR(cam_class)                                           \
  ([](I2CDriver& i2c_dev, int vdma_dev, int cam_id, bool main_cam)           \
       -> std::unique_ptr<I2CCamera> {                                       \
    return std::make_unique<cam_class>(i2c_dev, vdma_dev, cam_id, main_cam); \
  })

typedef std::unique_ptr<I2CCamera> (*cameraConstructor)(I2CDriver& i2c_dev,
                                                        int vdma_dev,
                                                        int cam_id,
                                                        bool main_cam);
typedef bool (*cameraProbe)(I2CDriver& i2c);

typedef struct camera_init_t
{
  cameraConstructor constructor;
  cameraProbe probe;
} camera_init_t;

const std::vector<camera_init_t> CAMERA_MODULES
{
  {CAM_CONSTRUCTOR(PiCameraV2), &PiCameraV2::probe},
#ifdef PROPRIETARY_SENSORS
      {CAM_CONSTRUCTOR(AR0234), &AR0234::probe},
      {CAM_CONSTRUCTOR(AR0521), &AR0521::probe},
      {CAM_CONSTRUCTOR(IMX490), &IMX490::probe},
#endif
};

#endif
