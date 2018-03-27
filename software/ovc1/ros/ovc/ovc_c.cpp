#include "ovc_c.h"
#include "ovc.h"
#include "ros/time.h"
#include "ovc_ioctl.h"

static OVC *g_ovc = NULL;
static uint8_t *g_img_buf = NULL;

int ovc_init()
{
  if (g_ovc)
    return 0;  // this is a singleton... don't initialize twice!
  g_img_buf = new uint8_t[OVC_IOCTL_DMA_BUF_SIZE];
  g_ovc = new OVC();
  if (!g_ovc->init()) {
    printf("ovc init failed :(\n");
    return -1;
  }
  g_ovc->set_sync_timing(20);
  ros::Time::init();
  return 0;  // success, C-style...
}

int ovc_fini()
{
  if (!g_ovc)
    return 0; // don't de-initialize twice
  delete g_ovc;
  g_ovc = NULL;
  delete[] g_img_buf;
  g_img_buf = NULL;
  return 0;
}

uint8_t *ovc_wait_for_image()
{
  if (!g_ovc)
    return NULL;
  static uint8_t *image_data = NULL;
  struct timespec ts;  // todo: return this somehow back to Python.
                       // maybe another function, like get_last_timestamp()?
  if (!g_ovc->wait_for_image(&image_data, ts))
    return NULL;
  memcpy(g_img_buf, image_data, OVC_IOCTL_DMA_BUF_SIZE);
  return g_img_buf;
}

void ovc_autoexposure(uint8_t *image)
{
  if (!g_ovc || !image)
    return;
  g_ovc->update_autoexposure_loop(image);
}
