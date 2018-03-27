#include <stdio.h>
#include "fpga.h"
#include "led.h"
#include "serial.h"
#include "systime.h"

int main(int argc, char **argv)
{
  printf("===\r\n");
  bool prev_pcierst = false;
  bool prev_fpga_power = false;
  while (1) {
    //for (volatile int i = 0; i < 1000000; i++) { }
    //led_toggle();
    //printf("hello %06d\n", hello_count);
    //hello_count++;
    serial_process_rx_ring();
    bool pcierst = fpga_poll_pcierst();
    bool fpga_power = fpga_is_powered();
    if (pcierst != prev_pcierst ||
        fpga_power != prev_fpga_power) {
      prev_pcierst = pcierst;
      prev_fpga_power = fpga_power;
      printf("%12u  PCIERST=%d  1V8=%d\r\n",
        (unsigned)SYSTIME_USECS, pcierst ? 1 : 0,
        (int)(fpga_power ? 1 : 0));
    }
    //if (
  }
  return 0;
}
