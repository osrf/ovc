#ifndef FLASH_H
#define FLASH_H

#include <stdint.h>

typedef enum { FLASH_SUCCESS, FLASH_FAIL } flash_result_t;

flash_result_t flash_erase_page(const uint32_t page);
flash_result_t flash_erase_page_by_addr(const uint32_t *addr);
flash_result_t flash_program_qword(const uint32_t *addr, const uint64_t qword);
flash_result_t flash_flush_d_cache();

#endif

