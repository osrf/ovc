#ifndef CAMERA_MODULES_INC
#define CAMERA_MODULES_INC

#include "ovc5_driver/camera.hpp"

// Append all the camera headers here
#include "ovc5_driver/cameras/picam_v2.hpp"
//#include <ovc4_driver/cameras/picam_hq.hpp>
#if PROPRIETARY_SENSORS
#include "ovc5_driver/cameras/ar0521.hpp"
#include "ovc5_driver/cameras/imx490.hpp"

#endif

#endif
