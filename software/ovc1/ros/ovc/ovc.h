#ifndef OVC_H_
#define OVC_H_

#include <ros/time.h>
#include <time.h>
#include "imager_register.h"
#include "ovc_imu_state.h"

class OVC
{
public:
  OVC();
  ~OVC();
  bool init();
  bool wait_for_image(uint8_t **p, struct timespec &t);
  bool wait_for_imu_state(OVCIMUState &imu_state, struct timespec &t);
  bool update_autoexposure_loop(uint8_t *image);
  bool set_exposure(float seconds);
  bool estimate_timestamp_offset();
  bool set_sync_timing(const uint8_t imu_decimation);
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
  bool set_corner_threshold(const uint8_t threshold);
  void hardware_time_to_system_time(
    const uint64_t t_hw, struct timespec &t_out);
  /////////////////////////////////
  bool init_complete;
  int fd, fd_imu;
  uint8_t *dma_buf;
public:
  double exposure_;
  // offsets between system time and hardware time
  struct timespec t_offset, t_prev_offset, t_prev_imu;
public:
  bool validate_signature(
    const uint8_t *img, const uint32_t len, const uint32_t *sig);
};

#endif
