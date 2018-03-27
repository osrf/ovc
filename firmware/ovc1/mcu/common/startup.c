#include <stdint.h>
#include <stdio.h>
#include "adc.h"
#include "console.h"
#include "fpga.h"
#include "led.h"
#include "serial.h"
#include "stack.h"
#include "stm32l452xx.h"
#include "systime.h"
#include "crc.h"

void __libc_init_array(void);  // i'm sure there is declared somewhere?

extern uint32_t _srelocate_flash, _srelocate, _erelocate, _ebss, _sbss;
extern int main(void);

void startup_clock_init_fail(void) { while (1) { } }

void reset_vector(void)
{
  //watchdog_reset_counter();
  g_stack[0] = 0; // need to put a reference in here to the stack array
                  // to make sure the linker brings it in. I'm sure there
                  // is a more elegant way to do this, but this seems to work
  // set up data segment
  uint32_t *pSrc = &_srelocate_flash;
  uint32_t *pDest = &_srelocate;
  if (pSrc != pDest)
    for (; pDest < &_erelocate; )
      *pDest++ = *pSrc++;
  // set up bss segment
  for (pDest = &_sbss; pDest < &_ebss; )
    *pDest++ = 0;
  SCB->CPACR |= ((3UL << 10*2)|(3UL << 11*2));  // magic line to turn on FPU
  __libc_init_array();

  // when the bootloader gets here, it needs to spin up the HSI and PLL
  // but when the application gets here, we don't need to do that again
  // so, test to see if HSI is already on, and skip past if possible
  if (!(RCC->CR & RCC_CR_HSION)) {
    RCC->CR |= RCC_CR_HSION; // enable HSI oscillator (16-mhz internal)
    // wait for either timeout or HSI to spin up
    for (uint32_t i = 0; i < 10000 && !(RCC->CR & RCC_CR_HSIRDY); i++);
    if (!(RCC->CR & RCC_CR_HSIRDY))
      startup_clock_init_fail();  // OH NOES. go spin forever.

    // HSI frequency is 16 MHz
    // we want:
    // VCO_CLK = 80 MHz * 2 = 160 MHz (PLLP = 2)
    // PLLCLK = 80 MHz
    // APB1 = 80 MHz
    // APB2 = 80 MHz
    // we want PLL output R to be 80 MHz, since this feeds PLLCLK
    // we do not need PLL outputs P and Q, so we won't enable them
    RCC->CFGR = RCC_CFGR_HPRE_0 |  // AHB is not divided from system clock
      RCC_CFGR_PPRE1_DIV1       |  // low-speed APB1 is syclk / 1 = 80 MHz
      RCC_CFGR_PPRE2_DIV1       ;  // high-speed APB2 is syclk / 1 = 80 MHz
    RCC->PLLCFGR =
      (  2 << RCC_PLLCFGR_PLLP_Pos) |  // output P = VCOCLK / 2 = 80 MHz
      (  0 << RCC_PLLCFGR_PLLR_Pos) |  // output R = VCOCLK / 2 = 80 MHz
      RCC_PLLCFGR_PLLREN            |  // enable output R
      (  0 << RCC_PLLCFGR_PLLQ_Pos) |  // output Q = VCOCLK / 2 = 80 MHz
      ( 20 << RCC_PLLCFGR_PLLN_Pos) |  // VCO is 160 MHz = 8 MHz * 20
      (  1 << RCC_PLLCFGR_PLLM_Pos) |  // divide HSI16 by 2 for 8 MHz PLL input
      RCC_PLLCFGR_PLLSRC_HSI;  // use HSI16 as PLL input
    RCC->CR |= RCC_CR_PLLON;  // start spinning up the PLL

    FLASH->ACR =
      FLASH_ACR_PRFTEN      |  // enable instruction cache prefetching
      FLASH_ACR_ICEN        |  // enable instruction cache
      FLASH_ACR_DCEN        |  // enable data cache
      FLASH_ACR_LATENCY_4WS ;  // 4 wait states needed @ 80 MHz CPU

    while (!(RCC->CR & RCC_CR_PLLRDY)) { }  // wait until PLL is spun up
    RCC->CFGR |= RCC_CFGR_SW_PLL;  // select PLL as system clock source
    while ((RCC->CFGR & RCC_CFGR_SWS) != RCC_CFGR_SWS_PLL) { }  // wait for it
  }

  // hooray we're done! we're now running at 80 MHz.
  static char stdout_buf[256];
  setvbuf(stdout, stdout_buf, _IOLBF, sizeof(stdout_buf));
  console_init();

  led_init();
  systime_init();
  adc_init();
  fpga_init();
  crc_init();
  serial_init();
  __enable_irq();
  main(); // jump to application main()
  while (1) { } // hopefully we never get here...
}
