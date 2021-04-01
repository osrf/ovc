#include "flash.h"
#include "stm32l452xx.h"
#include <stdio.h>
#include "systime.h"

static void flash_unlock();
static void flash_lock() __attribute__((unused)) ;
static flash_result_t flash_wait_for_idle();

flash_result_t flash_erase_page(const uint32_t page)
{
  if (page > 255)
    return FLASH_FAIL; // bogus sector 
  if (page < 32)
    return FLASH_FAIL; // protect bootloader !
  flash_unlock();
  flash_wait_for_idle();
  FLASH->CR &= ~0x7f8;  // zero out the previous page number bits
  FLASH->CR |= (page << 3);  // fill in the page number bits
  FLASH->CR |= FLASH_CR_PER;  // page erase operation
  FLASH->CR |= FLASH_CR_STRT; // start the page-erase operation
  flash_result_t result = flash_wait_for_idle();
  FLASH->CR &= ~FLASH_CR_PER; // reset the page-erase operation bit
  FLASH->CR &= ~0x7f8; // and wipe out the sector address bits
  //flash_lock(); // lock the flash again
  return result; // we're done
}

flash_result_t flash_erase_page_by_addr(const uint32_t *p)
{
  uint32_t addr = (uint32_t)p;
  if (addr <  0x08010000 ||
      addr >  0x0803ffff ||
      (addr & 0x7ff) != 0)  // must be aligned on 2k page boundary
    return FLASH_FAIL; // bad address
  int page = (addr - 0x08000000) / 0x800;
  return flash_erase_page(page);
}

void flash_unlock()
{
  // magic sequence to unlock flash...
  if (FLASH->CR & FLASH_CR_LOCK)
  {
    FLASH->KEYR = 0x45670123;
    FLASH->KEYR = 0xcdef89ab;
  }
  if (FLASH->CR & FLASH_CR_LOCK)
    printf("couldn't unlock flash\r\n");
}

void flash_lock() 
{
  FLASH->CR |= FLASH_CR_LOCK;
}

flash_result_t flash_wait_for_idle()
{
  //uint32_t t_start = SYSTIME_USECS;
  while (FLASH->SR & FLASH_SR_BSY)
  {
    /*
    // keep resetting the watchdog, since this may be a long-running erase op
    // give it 10 seconds of watchdog auto-resetting
    if (SYSTIME - t_start < 10000000)
      watchdog_reset_counter();
    */
  }
  // todo: check all the error bits, etc.
  if (FLASH->SR & 0xc3fb)
  {
    printf("unexpected FLASH_SR error bit: FLASH_SR = 0x%08lx\r\n",
           FLASH->SR);
    FLASH->SR |= (FLASH->SR & 0xc3fb); // clear the error bit(s)
    return FLASH_FAIL;
  }
  return FLASH_SUCCESS;
}

flash_result_t flash_program_qword(const uint32_t *addr, const uint64_t dword)
{
  if ((uint32_t)addr < 0x08010000)
    return FLASH_FAIL;  // protect the bootloader!
  flash_unlock();
  if (FLASH_FAIL == flash_wait_for_idle())
    return FLASH_FAIL;
  FLASH->CR |= FLASH_CR_PG; // set the programming bit
  *((volatile uint32_t *)addr) = *((volatile uint32_t *)&dword);
  *((volatile uint32_t *)addr+1) = *(((volatile uint32_t *)(&dword))+1);
  flash_result_t result = flash_wait_for_idle();
  FLASH->CR &= ~FLASH_CR_PG; // disable the programming bit
  //flash_lock();
  return result;
}

flash_result_t flash_flush_d_cache()
{
  // todo
  return FLASH_FAIL;
}

