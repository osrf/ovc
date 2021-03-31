#include "adc.h"
#include "delay.h"
#include "pin.h"
#include "stm32l452xx.h"

#define ADC_1V8_GPIO GPIOA
#define ADC_1V8_PIN  15

void adc_init()
{
  /*
  pin_set_analog(ADC_1V8_GPIO, ADC_1V8_PIN);
  RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;  // turn on ADC clock
  RCC->CCIPR |= RCC_CCIPR_ADCSEL_0 |
                RCC_CCIPR_ADCSEL_1 ;  // select sysclk as ADC clock

  ADC1->CR &= ~ADC_CR_DEEPPWD;  // turn off deep-power-down mode
  ADC1->CR |= ADC_CR_ADVREGEN;  // enable ADC voltage regulator
  delay_us(50);  // wait for ADC VREG stabilization, >= 20 usec
  ADC1->CR |= ADC_CR_ADCAL;  // start calibration sequence
  while (ADC1->CR & ADC_CR_ADCAL);  // wait until ADCAL goes back to 0
  delay_us(10);  // delay a few clocks after ADCAL goes back to 0
  ADC1->CFGR |= ADC_CFGR_CONT;  // enable continuous-conversion mode
  ADC1->ISR &= ~ADC_ISR_ADRDY;  // clear ADRDY
  ADC1->CR |= ADC_CR_ADEN;  // enable ADC
  ADC1->ADC_SQR1 = ADC_1V8_CHANNEL << 6;
  while (!(ADC1->ISR & ADC_ISR_ADRDY));  // wait for ADRDY to be set
  ADC1->CR |= ADSTART;
  */
}

float adc_poll_1v8_rail()
{
  // TODO: poll PA15. It should be around 1.8v once power supplies are ramped
  return 1.8f;  // TODO: not this
}
