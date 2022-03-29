#ifndef TIMER_DRIVER_HPP
#define TIMER_DRIVER_HPP

#include "ovc5_driver/uio_driver.hpp"

class Timer
{
private:
  // NOTE this is hardware dependent, 200 MHz
  static constexpr double CLOCK_FREQ = 10e7;

  static constexpr size_t MAP_SIZE = 0x10000;

  // Control and status, Load, Counter
  static constexpr unsigned int TCSR0 = 0x00 / sizeof(unsigned int);
  static constexpr unsigned int TLR0 = 0x04 / sizeof(unsigned int);
  static constexpr unsigned int TCR0 = 0x08 / sizeof(unsigned int);

  static constexpr unsigned int TCSR1 = 0x10 / sizeof(unsigned int);
  static constexpr unsigned int TLR1 = 0x14 / sizeof(unsigned int);
  static constexpr unsigned int TCR1 = 0x18 / sizeof(unsigned int);

  UIODriver uio;

  void reset();

public:
  Timer(int uio_num);

  ~Timer();

  void PWM(double freq, double high_time, bool invert_polarity = false);

  void interruptAtLine(int n);

  bool waitInterrupt();
};

#endif
