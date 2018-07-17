#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <signal.h>
#include "ovc2.h"

bool g_done = false;
void sigint_handler(int signum)
{
  g_done = true;
}

void usage()
{
  printf("usage:  ovc2_cli COMMAND [ARGUMENTS]\n");
  printf("  available commands:\n");
  printf("    set_bit REG_IDX BIT_IDX VALUE\n");
  printf("    spi_read BUS_IDX REG_IDX\n");
  printf("\n");
  exit(1);
}

int set_bit(int argc, char **argv, OVC2 *ovc2)
{
  if (argc < 5)
    usage();
  int reg_idx = atoi(argv[2]);
  int bit_idx = atoi(argv[3]);
  int bit_value = atoi(argv[4]);
  printf("set_bit(%d, %d, %d)\n", reg_idx, bit_idx, bit_value);
  return ovc2->set_bit(reg_idx, bit_idx, bit_value) ? 0 : 1;
}

int spi_read(int argc, char **argv, OVC2 *ovc2)
{
  if (argc < 4)
    usage();
  int bus = atoi(argv[2]);
  int reg = atoi(argv[3]);
  int val = ovc2->spi_read(bus, reg);
  if (val < 0) {
    printf("spi_read() rc = %d\n", val);
    return 1;
  }
  printf("spi_read(%d, %d) = 0x%08x\n", bus, reg, (unsigned)val);
  return 0;
}
 
int main(int argc, char **argv)
{
  if (argc < 2)
    usage();
  const char *cmd = argv[1];
  OVC2 ovc2;
  if (!ovc2.init()) {
    printf("bummer. OVC2 init failed.\n");
    return 1;
  }
  signal(SIGINT, sigint_handler);
  if (!strcmp(cmd, "set_bit"))
    return set_bit(argc, argv, &ovc2);
  else if (!strcmp(cmd, "spi_read"))
    return spi_read(argc, argv, &ovc2);
  else {
    printf("unknown command: %s\n", cmd);
    usage();
  }
  return 0;
}
