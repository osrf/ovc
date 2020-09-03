#ifndef GPIO_DRIVER_H
#define GPIO_DRIVER_H 1

#include "fsl_gpio.h"
#include "fsl_ctimer.h"

#include "usb_packetdef.h"

typedef struct CameraGPIO
{
  uint8_t port_num_;
  uint8_t gpio_num_;
  usb_rx_gpiocfg_t gpio_cfg_;

  // GPIO handle
  GPIO_Type* base_;

} CameraGPIO;

void cameragpio_init(GPIO_Type* base, CameraGPIO* gpio, uint8_t port_num, uint8_t gpio_num);

void cameragpio_process_packet(CameraGPIO gpio_arr[][GPIO_PER_CAM], usb_rx_packet_t *usb_pkt);

void cameragpio_reset_gpio(CameraGPIO* gpio);

void cameragpio_config_gpio(CameraGPIO* gpio, usb_rx_gpiocfg_t* cfg);

void cameragpio_set_output(CameraGPIO* gpio, int8_t enabled);

#endif
