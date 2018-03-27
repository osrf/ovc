#ifndef OVC_C_H
#define OVC_C_H

#include <stdint.h>

extern "C"
{
  int ovc_init();
  int ovc_fini();
  uint8_t *ovc_wait_for_image();
  void ovc_autoexposure(uint8_t *image);
}

#endif
