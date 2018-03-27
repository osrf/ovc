#include <stdlib.h>
#include <stdio.h>
#include <sys/stat.h>
#include "console.h"

extern int _end;

//#define PRINT_SBRK_CALLS

#ifdef PRINT_SBRK_CALLS
void write_integer_inefficiently(int x)
{
  int remainder = x;
  for (int order = 1000000000; order; order /= 10)
  {
    uint8_t digit = '0' + remainder / order;
    remainder -= (digit - '0') * order;
    console_send_block(&digit, 1);
  }
}
#endif

caddr_t _sbrk(int incr)
{
#ifdef PRINT_SBRK_CALLS
  console_send_block("sbrk ", 5);
  write_integer_inefficiently(incr);
  console_send_block("\r\n", 2);
#endif
  static unsigned char *heap = NULL ;
  unsigned char *prev_heap ;
  if ( heap == NULL )
    heap = (unsigned char *)&_end;
  prev_heap = heap;
  heap += incr ;
  return (caddr_t) prev_heap ;
}

int _kill(__attribute__((unused)) int pid, 
          __attribute__((unused)) int sig) { return -1; }
void _exit(__attribute__((unused)) int status) { while (1) {} } // spin...
int _getpid(void) { return 1; }

int _write(__attribute__((unused)) int fd, const void *buf, size_t count)
{
  console_send_block((uint8_t *)buf, count);
  return count;
}
int _close(__attribute__((unused)) int fd) { return -1; }
int _fstat(__attribute__((unused)) int fd, 
           __attribute__((unused)) struct stat *st)
{
  st->st_mode = S_IFCHR;
  return 0;
}
int _isatty(__attribute__((unused)) int fd) { return 1; }
off_t _lseek(__attribute__((unused)) int fd, 
             __attribute__((unused)) off_t offset, 
             __attribute__((unused)) int whence) { return 0; }
ssize_t _read(__attribute__((unused)) int fd, 
              __attribute__((unused)) void *buf, 
              __attribute__((unused)) size_t count) { return 0; }

struct __FILE { int handle; };
FILE __stdout;
FILE __stderr;
int fputc(__attribute__((unused)) int ch, __attribute__((unused)) FILE *f)
{
  return 0;
}
void _ttywrch(__attribute__((unused)) int ch)
{
}

//int _open(const char *pathname, int flags) { return -1; }
int _open(const char *pathname, int flags, mode_t mode) { return -1; }
