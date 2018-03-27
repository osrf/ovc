#include "delay.h"
#include "systime.h"

void delay_us(uint32_t us)
{
  if (us < 2)
    us = 2;
  volatile uint32_t t_start = SYSTIME_USECS;
  while (t_start + us > SYSTIME_USECS);
}

void delay_ms(uint32_t ms)
{
  volatile uint32_t t_start = SYSTIME_USECS;
  while (t_start + 1000 * ms > SYSTIME_USECS);
}
