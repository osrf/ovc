#ifndef FPGA_H
#define FPGA_H

#include <stdbool.h>

void fpga_init();

// FPGA configuration image starts 64K above flash base
#define FPGA_CONF_IMAGE_LEN   0x08010000
#define FPGA_CONF_IMAGE_START 0x08010008

bool fpga_config();

bool fpga_poll_pcierst();
bool fpga_is_powered();

#endif
