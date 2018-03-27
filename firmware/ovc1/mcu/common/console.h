#ifndef CONSOLE_H
#define CONSOLE_H

#include <stdint.h>

void console_init();
void console_send_block(const uint8_t *buf, uint32_t len);

#endif

