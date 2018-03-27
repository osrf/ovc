#ifndef STACK_H
#define STACK_H

#include <stdint.h>

// let's start with an 8K stack for now
#ifndef STACK_SIZE
#  define STACK_SIZE 8192
#endif

extern volatile uint8_t g_stack[STACK_SIZE];

#endif
