#ifndef OVC2_H
#define OVC2_H

#include "imager_register.h"

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
  bool reset_imagers();
  bool align_imager_lvds(const int imager_idx);
private:
  bool init_complete_;
  int fd_;
  bool enable_reg_ram();
	bool configure_imager(const int imager_idx);
  bool write_imager_reg(const int imager_idx, const ImagerRegister reg);
  bool read_imager_reg(const int imager_idx, ImagerRegister &reg);
};

}

#endif
