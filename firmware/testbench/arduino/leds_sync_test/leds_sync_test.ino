// neopixel featherwing uses pin 6
#include <Adafruit_NeoPixel.h>

#define LED_PIN 6
#define NUM_FAST_LEDS 8
#define NUM_LEDS 32
#define BRIGHTNESS 15

Adafruit_NeoPixel fast_pixels(NUM_FAST_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);
Adafruit_NeoPixel all_pixels(NUM_LEDS, LED_PIN, NEO_GRB + NEO_KHZ800);


void setup()
{
  all_pixels.begin();
  all_pixels.clear();
  all_pixels.show();
}

void increment_slow_pixel()
{
  static int slow_lit_pos = NUM_FAST_LEDS;

  all_pixels.setPixelColor(slow_lit_pos, 0, 0, 0);

  slow_lit_pos++;
  if (slow_lit_pos >= NUM_LEDS)
    slow_lit_pos = NUM_FAST_LEDS;

  all_pixels.setPixelColor(slow_lit_pos, BRIGHTNESS, 0, 0);

  all_pixels.show();
}

void increment_fast_pixel()
{
  static int lit_pos = 0;
  static int lit_chan = 1;

  lit_pos++;
  if (lit_pos >= NUM_FAST_LEDS)
  {
    lit_pos = 0;
    lit_chan++;
    if (lit_chan >= 3)
    {
      lit_chan = 0;
      increment_slow_pixel();
    }
  }

  fast_pixels.setPixelColor(
    lit_pos,
    (lit_chan == 0) ? BRIGHTNESS : 0,
    (lit_chan == 1) ? BRIGHTNESS : 0,
    (lit_chan == 2) ? BRIGHTNESS : 0);

  fast_pixels.show();
}

void loop()
{
  increment_fast_pixel();
}
