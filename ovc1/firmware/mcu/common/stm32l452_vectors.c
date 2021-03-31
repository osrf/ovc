#include <stdio.h>
#include "stack.h"
#include "startup.h"

void unhandled_vector(void)
{
  //printf("\noh noes! tried to execute unhandled vector %d (0x%x)\n",
  while (1) { }
  //arm_trap_unhandled_vector();
}

// declare weak symbols for all interrupt so they can be overridden easily
#define WEAK_VECTOR __attribute__((weak, alias("unhandled_vector")))

void nmi_vector() WEAK_VECTOR;
void hardfault_vector() WEAK_VECTOR;
void memmanage_vector() WEAK_VECTOR;
void busfault_vector() WEAK_VECTOR;
void usagefault_vector() WEAK_VECTOR;
void svcall_vector() WEAK_VECTOR;
void dbgmon_vector() WEAK_VECTOR;
void pendsv_vector() WEAK_VECTOR;
void systick_vector() WEAK_VECTOR;

void wwdg_vector() WEAK_VECTOR;
void pvd_vector() WEAK_VECTOR;
void tampstamp_vector() WEAK_VECTOR;
void rtc_wkup_vector() WEAK_VECTOR;
void flash_vector() WEAK_VECTOR;
void rcc_vector() WEAK_VECTOR;
void exti0_vector() WEAK_VECTOR;
void exti1_vector() WEAK_VECTOR;
void exti2_vector() WEAK_VECTOR;
void exti3_vector() WEAK_VECTOR;
void exti4_vector() WEAK_VECTOR;
void dma1_ch1_vector() WEAK_VECTOR;
void dma1_ch2_vector() WEAK_VECTOR;
void dma1_ch3_vector() WEAK_VECTOR;
void dma1_ch4_vector() WEAK_VECTOR;
void dma1_ch5_vector() WEAK_VECTOR;
void dma1_ch6_vector() WEAK_VECTOR;
void dma1_ch7_vector() WEAK_VECTOR;
void adc_vector() WEAK_VECTOR;
void can1_tx_vector() WEAK_VECTOR;
void can1_rx0_vector() WEAK_VECTOR;
void can1_rx1_vector() WEAK_VECTOR;
void can1_sce_vector() WEAK_VECTOR;
void exti9_5_vector() WEAK_VECTOR;
void tim1brk_tim15_vector() WEAK_VECTOR;
void tim1up_tim16_vector() WEAK_VECTOR;
void tim1trg_com_vector() WEAK_VECTOR;
void tim1cc_vector() WEAK_VECTOR;
void tim2_vector() WEAK_VECTOR;
void i2c1_ev_vector() WEAK_VECTOR;
void i2c1_er_vector() WEAK_VECTOR;
void i2c2_ev_vector() WEAK_VECTOR;
void i2c2_er_vector() WEAK_VECTOR;
void spi1_vector() WEAK_VECTOR;
void spi2_vector() WEAK_VECTOR;
void usart1_vector() WEAK_VECTOR;
void usart2_vector() WEAK_VECTOR;
void usart3_vector() WEAK_VECTOR;
void exti15_10_vector() WEAK_VECTOR;
void rtc_alarm_vector() WEAK_VECTOR;
void sdmmc1_vector() WEAK_VECTOR;
void spi3_vector() WEAK_VECTOR;
void tim6_dac_vector() WEAK_VECTOR;
void tim7_vector() WEAK_VECTOR;
void dma2_ch1_vector() WEAK_VECTOR;
void dma2_ch2_vector() WEAK_VECTOR;
void dma2_ch3_vector() WEAK_VECTOR;
void dma2_ch4_vector() WEAK_VECTOR;
void dma2_ch5_vector() WEAK_VECTOR;
void comp_vector() WEAK_VECTOR;
void lptim1_vector() WEAK_VECTOR;
void lptim2_vector() WEAK_VECTOR;
void usb_fs_vector() WEAK_VECTOR;
void dma2_ch6_vector() WEAK_VECTOR;
void dma2_ch7_vector() WEAK_VECTOR;
void lpuart1_vector() WEAK_VECTOR;
void quadspi_vector() WEAK_VECTOR;
void i2c3_ev_vector() WEAK_VECTOR;
void i2c3_er_vector() WEAK_VECTOR;
void sai1_vector() WEAK_VECTOR;
void swpwmi1_vector() WEAK_VECTOR;
void tsc_vector() WEAK_VECTOR;
void aes_vector() WEAK_VECTOR;
void rng_vector() WEAK_VECTOR;
void fpu_vector() WEAK_VECTOR;
void crs_vector() WEAK_VECTOR;

void dummy_reset_vector(void) { }

typedef void (*vector_func_t)(void);
__attribute__((section(".vectors"))) vector_func_t g_vectors[] =
{
    (vector_func_t)(&g_stack[STACK_SIZE-8]), // initial stack pointer
    reset_vector,
    nmi_vector,
    hardfault_vector,
    memmanage_vector,
    busfault_vector,
    usagefault_vector,
    0, 0, 0, 0,  
    svcall_vector,
    dbgmon_vector,
    0,                                      
    pendsv_vector,
    systick_vector,
    wwdg_vector,       // 0
    pvd_vector,        
    tampstamp_vector,
    rtc_wkup_vector,
    flash_vector,
    rcc_vector,
    exti0_vector,
    exti1_vector,
    exti2_vector,
    exti3_vector,
    exti4_vector,      // 10
    dma1_ch1_vector,
    dma1_ch2_vector,
    dma1_ch3_vector,
    dma1_ch4_vector,
    dma1_ch5_vector,
    dma1_ch6_vector,
    dma1_ch7_vector,
    adc_vector,
    can1_tx_vector,
    can1_rx0_vector,   // 20
    can1_rx1_vector,
    can1_sce_vector,
    exti9_5_vector,
    tim1brk_tim15_vector,
    tim1up_tim16_vector,
    tim1trg_com_vector,
    tim1cc_vector,
    tim2_vector,
    0,
    0,  // 30
    i2c1_ev_vector,
    i2c1_er_vector,
    i2c2_ev_vector,
    i2c2_er_vector,
    spi1_vector,
    spi2_vector,
    usart1_vector,
    usart2_vector,
    usart3_vector,
    exti15_10_vector,  // 40
    rtc_alarm_vector,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    sdmmc1_vector,
    0,  // 50
    spi3_vector,
    0,
    0,
    tim6_dac_vector,
    tim7_vector,
    dma2_ch1_vector,
    dma2_ch2_vector,
    dma2_ch3_vector,
    dma2_ch4_vector,
    dma2_ch5_vector,  // 60
    0,
    0,
    0,
    comp_vector,
    lptim1_vector,
    lptim2_vector,
    usb_fs_vector,
    dma2_ch6_vector,
    dma2_ch7_vector,
    lpuart1_vector,  // 70
    quadspi_vector,
    i2c3_ev_vector,
    i2c3_er_vector,
    sai1_vector,
    0,
    swpwmi1_vector,
    tsc_vector,
    0,
    aes_vector,
    rng_vector,  // 80
    fpu_vector,
    crs_vector
};

