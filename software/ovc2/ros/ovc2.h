#ifndef OVC2_H
#define OVC2_H

#include "imager_register.h"
#include "lightweightserial.h"
#include "../modules/ovc2_core/ovc2_ioctl.h"

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
  bool wait_for_imu_data(bool print_to_console = false);
  struct ovc2_imu_data imu_data_;
private:
  bool init_complete_;
  int fd_, fd_imu_;
  LightweightSerial *imu_serial;
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
