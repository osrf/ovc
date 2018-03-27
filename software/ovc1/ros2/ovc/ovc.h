#ifndef OVC_H_
#define OVC_H_

#include "imager_register.h"

class OVC
{
public:
  OVC();
  ~OVC();
  bool init();
  bool wait_for_image(uint8_t **p);
  static const int IMAGE_WIDTH = 1280;
  static const int IMAGE_HEIGHT = 2048;

private:
  bool pio_set(int pio_idx, bool state);
  bool configure_imagers();
  bool configure_imager(int imager_idx);
  bool write_imager_reg(const uint8_t imager_idx, const ImagerRegister reg);
  bool read_imager_reg(const uint8_t imager_idx, ImagerRegister &reg);
  bool align_imager_lvds(const int imager_idx);
  bool configure_imu();
  bool enable_register_ram_paging();
  bool set_sync_timing(const uint8_t imu_decimation);
  bool set_exposure(float seconds);
  /////////////////////////////////
  bool init_complete;
  int fd;
  uint8_t *dma_buf;
public:
  bool validate_signature(
    const uint8_t *img, const uint32_t len, const uint32_t *sig);
};

#endif
