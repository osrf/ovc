#ifndef OVC2_H
#define OVC2_H

class OVC2
{
public:
  OVC2();
  ~OVC2();
  bool init();
  bool set_bit(int reg_idx, int bit_idx, bool bit_value);
  int spi_read(int bus, int reg);
private:
  bool init_complete_;
  int fd_;
  bool enable_reg_ram();
};

#endif
