#include <stdio.h>
#include "delay.h"
#include "fpga.h"
#include "led.h"
#include "pin.h"
#include "stm32/stm32l452xx.h"

#define CONF_DONE_GPIO GPIOB
#define CONF_DONE_PIN  0

#define NSTATUS_GPIO GPIOB
#define NSTATUS_PIN  1

#define CVP_DONE_GPIO GPIOA
#define CVP_DONE_PIN 0

#define NCONFIG_GPIO GPIOA
#define NCONFIG_PIN  4

#define DCLK_GPIO GPIOA
#define DCLK_PIN 1

#define DATA_GPIO GPIOA
#define DATA_PIN  7

#define CONFIG_SPI SPI1
#define SPI1_AF 5

#define PCIE_RST_GPIO GPIOB
#define PCIE_RST_PIN  12

#define FPGA_1V8_GPIO GPIOA
#define FPGA_1V8_PIN 15

void fpga_init()
{
  pin_set_input(FPGA_1V8_GPIO, FPGA_1V8_PIN, false, false);
  RCC->APB2ENR |= RCC_APB2ENR_SPI1EN;
  pin_set_alternate_function(DCLK_GPIO, DCLK_PIN, SPI1_AF);
  pin_set_alternate_function(DATA_GPIO, DATA_PIN, SPI1_AF);
  pin_set_output(NCONFIG_GPIO, NCONFIG_PIN, false);
  pin_set_output_speed(DCLK_GPIO, DCLK_PIN, 3);  // max beef
  pin_set_output_speed(DATA_GPIO, DATA_PIN, 3);  // max beef
  pin_set_input(NSTATUS_GPIO, NSTATUS_PIN, false, false);
  pin_set_input(CONF_DONE_GPIO, CONF_DONE_PIN, false, false);
  pin_set_input(PCIE_RST_GPIO, PCIE_RST_PIN, false, false);
  CONFIG_SPI->CR1  = 0                |  // clock phase: cpol=0, cpha=0
                     SPI_CR1_MSTR     |  // master mode
                     SPI_CR1_SSM      |  // software slave management
                     SPI_CR1_SSI      |  // software slave management
                     SPI_CR1_LSBFIRST |  // send LSB first as per C5 datasheet
                     SPI_CR1_BR_2     |  // baud rate = pclk/16 = 80/16
                     SPI_CR1_BR_1     |  // baud rate = pclk/16 = 80/16
                     SPI_CR1_BR_0     ;  // baud rate = pclk/16 = 80/16
  CONFIG_SPI->CR2  = SPI_CR2_DS_2 |
                     SPI_CR2_DS_1 |
                     SPI_CR2_DS_0 ;  // select 8-bit data size
  CONFIG_SPI->CR1 |= SPI_CR1_SPE  ;  // enable SPI
}

bool fpga_config()
{
  const uint32_t image_len = *((uint32_t *)FPGA_CONF_IMAGE_LEN);
  printf("found %d-byte periphery image\n", (int)image_len);
  if (image_len > 100000) {
    printf("image looks suspiciously large. Not using it...\n");
    return false;
  }
  led_on();
  pin_set_output_high(NCONFIG_GPIO, NCONFIG_PIN);
  delay_us(100);
  pin_set_output_low(NCONFIG_GPIO, NCONFIG_PIN);
  delay_us(10);
  pin_set_output_high(NCONFIG_GPIO, NCONFIG_PIN);
  delay_us(10);  // needs to be at least 2 usec...
  printf("waiting for status to go high...\n");
  while (!pin_get_state(NSTATUS_GPIO, NSTATUS_PIN));
  printf("sending image...\n");
  CONFIG_SPI->CR1 |= SPI_CR1_SPE  ;  // enable SPI
  // NOTE: the SPI peripheral is 16-bit, so unless you explicitly
  // do 8-bit transfers into the FIFO, it will act like it's
  // receiving a 16-bit write (with the top 8 bits zero)
  // since all of our images are always going to be even numbers
  // of bytes anyway, we'll just do 16-bit transfers all the time
  const uint16_t *image = (const uint16_t *)FPGA_CONF_IMAGE_START;
  for (uint32_t i = 0; i < image_len/2 + 1; i++) {
    while (!(CONFIG_SPI->SR & SPI_SR_TXE));  // wait for TX buffer room
    CONFIG_SPI->DR = image[i];
  }
  printf("waiting for last byte...\n");
  while (CONFIG_SPI->SR & SPI_SR_BSY);  // wait for last byte to finish
  printf("done. NSTATUS=%d\n", pin_get_state(NSTATUS_GPIO, NSTATUS_PIN)?1:0);
  CONFIG_SPI->DR = 0;  // drive this line low at idle
  while (CONFIG_SPI->SR & SPI_SR_BSY);  // wait for last byte to finish
  CONFIG_SPI->CR1 &= ~SPI_CR1_SPE;  // disable SPI
  printf("waiting for CONF_DONE to be released...\n");
  while (!pin_get_state(CONF_DONE_GPIO, CONF_DONE_PIN));
  led_off();
  printf("done!\n");
  return true;
}

bool fpga_poll_pcierst()
{
  return pin_get_state(PCIE_RST_GPIO, PCIE_RST_PIN);
}

bool fpga_is_powered()
{
  return pin_get_state(FPGA_1V8_GPIO, FPGA_1V8_PIN);
}

#if 0
// graveyard
uint16_t enc_poll()
{
  pin_set_output_low(CS_GPIO, CS_PIN);
  ENC_SPI->DR;  // make sure we've flushed the RX register
  ENC_SPI->DR = 0xffff;
  while (!(ENC_SPI->SR & SPI_SR_RXNE)) { }  // wait for it...
  pin_set_output_high(CS_GPIO, CS_PIN);
  return ENC_SPI->DR & 0x3fff; // returns the result of the previous call
}
#endif
