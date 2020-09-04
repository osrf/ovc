#include "camera_gpio.h"

// There is a single global timer to synchronize all the cameras
#define CTIMER CTIMER2
#define CTIMER_MAT_OUT kCTIMER_Match_1
#define CTIMER_CLK_FREQ CLOCK_GetCTimerClkFreq(2)

#define FRAME_TRIGGER_PORT 1
#define FRAME_TRIGGER_GPIO 6

static uint32_t trigger_mask[2] = {0, 0}; // Mask used to set / clear pins, Port 0 is unused

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

static void cameragpio_set_frame_trigger()
{
  gpio_pin_config_t gpio_config = {
    .pinDirection = kGPIO_DigitalOutput,
    .outputLogic = 0
  };
  GPIO_PinInit(GPIO, FRAME_TRIGGER_PORT, FRAME_TRIGGER_GPIO, &gpio_config);
  trigger_mask[FRAME_TRIGGER_PORT] |= (1 << FRAME_TRIGGER_GPIO);
}

void cameragpio_reset_gpio(CameraGPIO* gpio)
{
  // TODO if a timer interrupt was attached (i.e. Trigger output) detach it

}

static void trigger_timer_callback(uint32_t flags)
{
  // Toggle pins here
  // TODO duty cycle
  GPIO_PortToggle(GPIO, 0, trigger_mask[0]);
  GPIO_PortToggle(GPIO, 1, trigger_mask[1]);
}

static ctimer_callback_t trigger_timer_cb_ptr = trigger_timer_callback;

static void cameragpio_set_timer(float freq)
{
  // Set frame trigger output as well
  cameragpio_set_frame_trigger();
  // TODO parametrize duty cycle, 50% for now
  CLOCK_AttachClk(kFRO_HF_to_CTIMER2);
  ctimer_config_t config;
  ctimer_match_config_t match_config;
  CTIMER_GetDefaultConfig(&config);
  CTIMER_Init(CTIMER, &config);

  match_config.enableCounterReset = true;
  match_config.enableCounterStop = false;
  match_config.matchValue = CTIMER_CLK_FREQ / (2 * freq);
  match_config.outControl = kCTIMER_Output_NoAction;
  match_config.outPinInitState = false;
  match_config.enableInterrupt = true;
  CTIMER_RegisterCallBack(CTIMER, &trigger_timer_cb_ptr, kCTIMER_SingleCallback);
  CTIMER_SetupMatch(CTIMER, CTIMER_MAT_OUT, &match_config);
  CTIMER_StartTimer(CTIMER);
}

static void cameragpio_set_trigger_mask(CameraGPIO* gpio)
{
  trigger_mask[gpio->port_num_] |= (1 << gpio->gpio_num_);
}

static void cameragpio_reset_trigger_mask(CameraGPIO* gpio)
{
  trigger_mask[gpio->port_num_] &= ~(1 << gpio->gpio_num_);
}

void cameragpio_config_gpio(CameraGPIO* gpio, usb_rx_gpiocfg_t* cfg)
{
  switch (cfg->function)
  {
    case CAMGPIO_ENABLE:
    {
      cameragpio_reset_trigger_mask(gpio);
      cameragpio_set_output(gpio, cfg->enabled);
      break;
    }
    case CAMGPIO_TRIGGER:
    {
      // TODO implement
      // Update the mask
      cameragpio_set_output(gpio, !cfg->trigger_polarity);
      cameragpio_set_trigger_mask(gpio);
      cameragpio_set_timer(cfg->trigger_frequency);

      break;
    }
    case CAMGPIO_EXTCLK:
    {
      // Unimplemented
      cameragpio_reset_trigger_mask(gpio);
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
