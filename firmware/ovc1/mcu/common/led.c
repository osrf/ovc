#include "led.h"
#include "pin.h"

#define LED_GPIO GPIOB
#define LED_PIN  9

void led_init()
{
  pin_set_output(LED_GPIO, LED_PIN, 0);
}

void led_on()
{
  pin_set_output_high(LED_GPIO, LED_PIN);
}

void led_off()
{
  pin_set_output_low(LED_GPIO, LED_PIN);
}

void led_toggle()
{
  pin_toggle_state(LED_GPIO, LED_PIN);
}
