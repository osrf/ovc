#ifndef OVC2_H
#define OVC2_H

#include "imager_register.h"
#include "lightweightserial.h"

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
private:
  bool init_complete_;
  int fd_;
  LightweightSerial *imu_serial;
  bool enable_reg_ram();
	bool configure_imager(const int imager_idx);
  bool write_imager_reg(const int imager_idx, const ImagerRegister reg);
  bool read_imager_reg(const int imager_idx, ImagerRegister &reg);

  bool write_imu_reg_str(const char * const request);
  bool imu_append_checksum(char *request);
};

}

#endif
