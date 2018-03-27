#include <stdio.h>
#include "led.h"

int main(int argc, char **argv)
{
  int hello_count = 0;
  while (1) {
    for (volatile int i = 0; i < 1000000; i++) { }
    led_toggle();
    printf("hello %06d\n", hello_count);
    hello_count++;
  }
  return 0;
}
