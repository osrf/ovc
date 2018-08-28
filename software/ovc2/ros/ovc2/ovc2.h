#ifndef OVC2_H
#define OVC2_H

#include "imager_register.h"
#include "lightweightserial.h"
#include "ovc2_ioctl.h"
#include "ovc2_imu_state.h"

namespace ovc2
{

class OVC2
{
public:
  OVC2();
  ~OVC2();
  bool init();
  bool set_bit(const int reg_idx, const int bit_idx, const bool bit_value);
  int spi_read(const int bus, const int reg);
  bool configure_imagers();
  bool configure_imu();
  bool reset_imagers();
  bool align_imager_lvds(const int imager_idx);
  bool wait_for_imu_state(OVC2IMUState &imu_state, struct timespec &t);
  bool wait_for_image(uint8_t **p, struct timespec &t);
  bool set_exposure(float seconds);
  bool set_sync_timing(const uint32_t decimation);
  bool set_corner_threshold(const uint8_t threshold);
  struct ovc2_imu_data imu_data_;
  bool update_autoexposure_loop(uint8_t *image);
  double get_exposure() { return exposure_; }
private:
  bool init_complete_;
  int fd_, fd_imu_, fd_cam_;
  LightweightSerial *imu_serial_;
  uint8_t *cam_dma_buf_;
  double exposure_;

  bool enable_reg_ram();
	bool configure_imager(const int imager_idx);
  bool write_imager_reg(const int imager_idx, const ImagerRegister reg);
  bool read_imager_reg(const int imager_idx, ImagerRegister &reg);

  bool write_imu_reg_str(const char * const request);
  bool imu_append_checksum(char *request);
  bool imu_set_auto_poll(bool enable);
};

}

#endif
