#include "console.h"
#include "led.h"
#include "pin.h"
#include "stm32l452xx.h"

// pin connections
// PA9  = USART1 TX as AF7
// PA10 = USART1 RX as AF7

#define CONSOLE_GPIO  GPIOA
#define CONSOLE_USART USART1
#define CONSOLE_AF 7
#define TX_PIN  9
#define RX_PIN 10

static volatile bool g_console_init_complete = false;

// USART1 clock hangs from APB2 = 80 MHz

void console_init()
{
  g_console_init_complete = true;
  RCC->APB2ENR |= RCC_APB2ENR_USART1EN;
  pin_set_alternate_function(CONSOLE_GPIO, TX_PIN, CONSOLE_AF);
  CONSOLE_USART->CR1 &= ~USART_CR1_UE;
  CONSOLE_USART->CR1 |=  USART_CR1_TE;
  // baud rate = F_CK / USARTDIV
  // for 1 Mbaud we want USARTDIV = 80M / 1M = 80
  CONSOLE_USART->BRR  = 80;
  CONSOLE_USART->CR1 |=  USART_CR1_UE;
}

void console_send_block(const uint8_t *buf, uint32_t len)
{
  if (!g_console_init_complete)
    console_init();
  for (uint32_t i = 0; i < len; i++)
  {
    while (!(CONSOLE_USART->ISR & USART_ISR_TXE)) { } // wait for tx to clear
    CONSOLE_USART->TDR = buf[i];
  }
  while (!(CONSOLE_USART->ISR & USART_ISR_TC)) { } // wait for TX to finish
}
