#ifndef SYSTIME_H
#define SYSTIME_H

#include "stm32l452xx.h"

void systime_init();

#define SYSTIME_USECS (TIM2->CNT)

#endif
