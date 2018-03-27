#include <cstdio>
#include <cstdlib>
#include <cstring>
#include "lightweightserial.h"
#include <signal.h>
#include <unistd.h>

void perish_if(bool b, const char *msg)
{
  if (b)
  {
    printf("%s\n", msg);
    exit(1);
  }
}

static bool g_done = false;
void signal_handler(int signum)
{
  if (signum == SIGINT)
    g_done = true;
}

void usage()
{
  printf("usage:  console DEVICE\n");
  exit(1);
}

int main(int argc, char **argv)
{
  signal(SIGINT, signal_handler);
  if (argc != 2)
    usage();
  const char *serial_device = argv[1];
  LightweightSerial *port = new LightweightSerial(serial_device, 1000000);
  perish_if(!port, "could't open the specified serial port");
  uint8_t b = 0;
  while (port->is_ok() && !g_done)
  {
    if (port->read(&b))
    {
      putc(b, stdout);
      fflush(stdout);
    }
    else
      usleep(1000);
  }
  return 0;
}

