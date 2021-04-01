#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "delay.h"
#include "fpga.h"
#include "led.h"
#include "pin.h"
#include "serial.h"
#include "systime.h"

int main(int argc, char **argv)
{
  printf("===\n");
  bool prev_pcierst = fpga_poll_pcierst();
  bool prev_fpga_power = fpga_is_powered();
  if (prev_fpga_power)
    printf("fpga already powered; not configuring it...\n");
 
  while (1) {
    serial_process_rx_ring();
    bool pcierst = fpga_poll_pcierst();
    bool fpga_power = fpga_is_powered();
    if (fpga_power && !prev_fpga_power) {
      delay_ms(100);  // wait a while... no rush.
      printf("%12u starting configuration...\n", (unsigned)SYSTIME_USECS);
      fpga_config();
      printf("%12u done with config.\n", (unsigned)SYSTIME_USECS);
    }
    prev_fpga_power = fpga_power;

    if (pcierst != prev_pcierst) {
      prev_pcierst = pcierst;
      printf("%12u  PCIERST=%d  1V8=%d\r\n",
        (unsigned)SYSTIME_USECS, pcierst ? 1 : 0,
        (int)(fpga_power ? 1 : 0));
    }
 
    /*
    if (fpga_poll_pcierst())
      led_on();
    else
      led_off();
    */
  }
  return 0;  // never gets here
}
