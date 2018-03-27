#include <stdint.h>
#include "systime.h"
#include "stm32l452xx.h"

// we'll use TIM2 since it's the only 32-bit timer on this chip

void systime_init()
{
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
  TIM2->PSC = 80-1;  // divide APB1 clock by 48 to count microseconds
  TIM2->ARR = 0xffffffff;  // count as long as possible
  TIM2->EGR = TIM_EGR_UG;  // load PSC register immediately
  TIM2->CR1 = TIM_CR1_CEN;  // start counter
}
