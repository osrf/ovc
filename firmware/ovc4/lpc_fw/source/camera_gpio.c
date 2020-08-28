#include "camera_gpio.h"


void cameragpio_init(GPIO_Type* base, CameraGPIO* gpio, uint8_t port_num, uint8_t gpio_num)
{
  gpio->base_ = base;
  gpio->port_num_ = port_num;
  gpio->gpio_num_ = gpio_num;
}

void cameragpio_process_packet(CameraGPIO gpio_arr[][GPIO_PER_CAM], usb_rx_packet_t *usb_pkt)
{
  // Iterate over cameras
  for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
  {
    // And over number of GPIOs per camera
    for (int gpio_id = 0; gpio_id < GPIO_PER_CAM; ++gpio_id)
    {
      usb_rx_gpiocfg_t* old_cfg = &gpio_arr[cam_id][gpio_id].gpio_cfg_;
      usb_rx_gpiocfg_t* new_cfg = &usb_pkt->gpio[cam_id][gpio_id];
      // If the functionality changed reset the pin first
      if (new_cfg->function != old_cfg->function)
        cameragpio_reset_gpio(&gpio_arr[cam_id][gpio_id]);
      cameragpio_config_gpio(&gpio_arr[cam_id][gpio_id], new_cfg);
      
    }
  }
}

void cameragpio_reset_gpio(CameraGPIO* gpio)
{
  // TODO if a timer interrupt was attached (i.e. Trigger output) detach it

}

void cameragpio_config_gpio(CameraGPIO* gpio, usb_rx_gpiocfg_t* cfg)
{
  switch (cfg->function)
  {
    case CAMGPIO_UNUSED:
    {
      // Noop
      break;
    }
    case CAMGPIO_ENABLE:
    {
      cameragpio_set_output(gpio, cfg->enabled);
      break;
    }
    case CAMGPIO_TRIGGER:
    {
      // TODO implement

      break;
    }
    case CAMGPIO_EXTCLK:
    {
      // Unimplemented
      break;
    }
    default:
    {
      // Force 16 bit not handled
    }
  }

}

void cameragpio_set_output(CameraGPIO* gpio, int8_t enabled)
{
  gpio_pin_config_t gpio_config = {
    .pinDirection = kGPIO_DigitalOutput,
    .outputLogic = enabled
  };
  GPIO_PinInit(gpio->base_, gpio->port_num_, gpio->gpio_num_, &gpio_config);
}
