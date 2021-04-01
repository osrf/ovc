#include "stack.h"

// hai can i have a stack plz
volatile __attribute__((used,aligned(8),section(".stack"))) uint8_t g_stack[STACK_SIZE];
