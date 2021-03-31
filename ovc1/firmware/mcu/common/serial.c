#include <stdio.h>
#include <string.h>
#include "crc.h"
#include "flash.h"
#include "fpga.h"
#include "pin.h"
#include "serial.h"

#define SERIAL_GPIO   GPIOA
#define SERIAL_TX_PIN 2
#define SERIAL_RX_PIN 3
#define SERIAL_ALT_FUNC 7
#define SERIAL_USART USART2

#define SERIAL_RX_RING_LEN 512
static volatile uint8_t g_serial_rx_ring[SERIAL_RX_RING_LEN];
static volatile uint32_t g_serial_rx_ring_rpos = 0;
static volatile uint32_t g_serial_rx_ring_wpos = 0;

/*
// not needed anymore...
#define SERIAL_TX_BUF_LEN 260
static volatile uint8_t g_serial_tx_buf[SERIAL_TX_BUF_LEN];
*/

void serial_init()
{
  pin_set_alternate_function(SERIAL_GPIO, SERIAL_TX_PIN, SERIAL_ALT_FUNC);
  pin_set_alternate_function(SERIAL_GPIO, SERIAL_RX_PIN, SERIAL_ALT_FUNC);
  RCC->APB1ENR1 |= RCC_APB1ENR1_USART2EN;
  SERIAL_USART->CR1 &= ~USART_CR1_UE;  // make sure it's disabled
  SERIAL_USART->CR1 |= USART_CR1_TE | USART_CR1_RE |  // enable tx and rx
                       USART_CR1_PCE |  // enable (even) parity
                       USART_CR1_M0  |  // 9-bit data (MSB is parity)
                       USART_CR1_RXNEIE;  // enable RX interrupt
  // baud rate = PCLK1 / USARTDIV
  // we want 115200 = 80M / 115200 ~= 694
  SERIAL_USART->BRR = 694;
  NVIC_SetPriority(USART2_IRQn, 3);
  NVIC_EnableIRQ(USART2_IRQn);
  SERIAL_USART->CR1 |= USART_CR1_UE;  // re-enable the UART
}

void usart2_vector()
{
  volatile uint8_t __attribute__((unused)) sr = SERIAL_USART->ISR;
  volatile uint8_t b = SERIAL_USART->RDR;
  g_serial_rx_ring[g_serial_rx_ring_wpos] = b;
  if (++g_serial_rx_ring_wpos >= SERIAL_RX_RING_LEN)
    g_serial_rx_ring_wpos = 0;  // wrap
}

static void tx_sync(const uint8_t *p, const uint32_t len)
{
  if (len <= 0 || len > 255) {
    printf("bad tx_sync packet size: %d\n", (int)len);
    return;
  }
  for (uint32_t i = 0; i < len; i++) {
    while (!(SERIAL_USART->ISR & USART_ISR_TXE));  // wait for TX buffer space
    //printf("sending 0x%02x\n", (unsigned)p[i]);
    SERIAL_USART->TDR = p[i];
  }
}

static void send_packet(const uint8_t *p, const uint32_t len)
{
  if (len <= 0 || len > 255) {
    printf("bad tx packet size: %d\n", (int)len);
    return;
  }
  //printf("sending %d-byte packet\n", (int)len);
  uint8_t header[2] = { 0x42, (uint8_t) len };
  tx_sync(header, 2);
  uint8_t csum = (uint8_t)len;
  for (int i = 0; i < len; i++)
    csum += i + p[i];
  tx_sync(p, len);
  csum = ~csum;
  tx_sync(&csum, 1);
}

void serial_process_payload(const uint8_t *p, const uint8_t len)
{
  //printf("serial_process_payload(%d)\n", len);
  if (len == 0)
    return;
  const uint8_t cmd = p[0];
  //printf("cmd == %d\n", (int)p[0]);
  if (cmd == 1) {
    //printf("ping\n");
    uint8_t response = 2;
    send_packet(&response, 1);
  }
  else if (cmd == 2) {
    if (len < 6) {
      printf("memory-read request needs to be >= 6 bytes\n");
      return;
    }
    uint8_t len = p[1];
    uint32_t start_addr;
    memcpy(&start_addr, &p[2], 4);
    /*
    printf("memory-read request: %d bytes at 0x%08x\r\n",
      len, (unsigned)start_addr);
    */
    send_packet((uint8_t *)start_addr, len);
  }
  else if (cmd == 3) {
    if (len <= 6) {
      printf("memory-write request needs to be > 6 bytes\n");
      return;
    }
    uint8_t len = p[1];
    uint32_t start_addr;
    memcpy(&start_addr, &p[2], 4);
    //printf("memory-write request: %d bytes at 0x%08x\n",
    //  (int)len, (unsigned)start_addr);
    if (len % 8 != 0) {
      printf("for now, we can only program flash in 64-bit qwords :(\n");
      return;
    }
    for (int offset = 0; offset < len; offset += 8) {
      const uint32_t addr = start_addr + offset;
      if ((addr & 0x7ff) == 0) {
        printf("erasing page 0x%08x\r\n", (unsigned)addr);
        if (FLASH_SUCCESS != flash_erase_page_by_addr((uint32_t *)addr)) {
          printf("failed to erase page :(\r\n");
          uint8_t response = 1;
          send_packet(&response, 1);
        }
      }
      uint64_t qword;
      memcpy(&qword, &p[6 + offset], 8);
      if (FLASH_SUCCESS != flash_program_qword((uint32_t *)addr, qword)) {
        printf("failed to program flash :(\n");
        uint8_t response = 1;
        send_packet(&response, 1);
        return;
      }
    }
    uint8_t response = 0;
    send_packet(&response, 1);
  }
  else if (cmd == 4) {
    printf("config command received\n");
    uint8_t response = 0;
    if (fpga_config())
      response = 1;
    send_packet(&response, 1);
  }
  else if (cmd == 5) {
    printf("crc32 request received\n");
    const uint32_t image_len = *((uint32_t *)FPGA_CONF_IMAGE_LEN);
    printf("found %d-byte periphery image\n", (int)image_len);
    uint32_t response = 0;
    if (image_len > 100000) {
      printf("image looks suspiciously large. Not using it...\n");
    }
    else {
      response = crc_fast((uint8_t *)FPGA_CONF_IMAGE_START, image_len);
    }
    send_packet((uint8_t *)&response, 4);
  }
  else {
    printf("unknown command: 0x%02x\n", cmd);
  }
}

typedef enum
{
  PS_START,
  PS_LENGTH,
  PS_DATA,
  PS_CSUM
} parser_state_t;

static void serial_process_byte(uint8_t b)
{
  static parser_state_t ps = PS_START;
  static uint8_t expected_len = 0;
  static uint8_t payload[256] = {0};
  static uint8_t payload_wpos = 0;
  static uint8_t payload_csum = 0;
  //printf("0x%02x\r\n", b);
  switch (ps)
  {
    case PS_START:
      if (b == 0x42)
        ps = PS_LENGTH;
      break;
    case PS_LENGTH:
      expected_len = b;
      payload_wpos = 0;
      payload_csum = b;
      ps = PS_DATA;
      break;
    case PS_DATA:
      payload_csum += b + payload_wpos;
      payload[payload_wpos++] = b;
      if (payload_wpos >= expected_len)
        ps = PS_CSUM;
      break;
    case PS_CSUM:
      if ((~b & 0xff) == payload_csum)
        serial_process_payload(payload, expected_len);
      else
      {
        printf("csum mismatch: expected 0x%02x received 0x%02x\r\n",
               (~payload_csum) & 0xff, b);
      }
      ps = PS_START;
      break;
    default:
      ps = PS_START;
      break;
  }
}

void serial_process_rx_ring()
{
  while (g_serial_rx_ring_rpos != g_serial_rx_ring_wpos)
  {
    serial_process_byte(g_serial_rx_ring[g_serial_rx_ring_rpos]);
    if (++g_serial_rx_ring_rpos >= SERIAL_RX_RING_LEN)
      g_serial_rx_ring_rpos = 0;  // wrap
  }
}
