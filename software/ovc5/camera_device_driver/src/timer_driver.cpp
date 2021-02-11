#include <iostream>
#include <unistd.h>

#include <ovc5_driver/timer_driver.hpp>


TimerDriver::TimerDriver(int uio_num)
: uio(uio_num, MAP_SIZE)
{
}

void TimerDriver::reset()
{
  uio.writeRegister(TCSR0, 0x00);
  uio.writeRegister(TCSR1, 0x00);
}

// We operate with two timers to commute between high and low in PWM mode
// TODO implement invert_polarity
void TimerDriver::start(double freq, double high_time, bool /*invert_polarity*/)
{
  reset();
  // Period set through timer0, high time set through timer1
  uint32_t target_freq_register = CLOCK_FREQ / freq;
  uio.writeRegister(TLR0, target_freq_register);

  uint32_t target_high_register = CLOCK_FREQ * high_time;
  uio.writeRegister(TLR1, target_high_register);

  uint32_t ctrl_val = 0;
  ctrl_val |= (1 << 5); // Load TLR value
  uio.writeRegister(TCSR0, ctrl_val);
  uio.writeRegister(TCSR1, ctrl_val);
  ctrl_val = 0;

  ctrl_val |= (1 << 9); // Enable PWM
  ctrl_val |= (1 << 4); // Auto reload
  ctrl_val |= (1 << 2); // Enable generate output
  ctrl_val |= (1 << 1); // Count down
  uio.writeRegister(TCSR0, ctrl_val);

  uio.writeRegister(TCSR1, ctrl_val);
  ctrl_val |= (1 << 10); // Enable all, starts timer
  uio.writeRegister(TCSR1, ctrl_val);
}
