#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fcntl.h>      // open
#include <sys/ioctl.h>  // ioctl
#include <sys/mman.h>   // mmap
#include <signal.h>
#include <unistd.h>
#include "../modules/ovc2_core/ovc2_ioctl.h"

int g_fd = 0;
static const char * const OVC2_DEVICE = "/dev/ovc2_core";

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
  printf("\n");
  exit(1);
}

int set_bit(int argc, char **argv)
{
  if (argc < 5)
    usage();
  int reg_idx = atoi(argv[2]);
  int bit_idx = atoi(argv[3]);
  int bit_value = atoi(argv[4]);
  printf("set_bit(%d, %d, %d)\n", reg_idx, bit_idx, bit_value);
  struct ovc2_ioctl_set_bit sb;
  sb.reg_idx = reg_idx;
  sb.bit_idx = bit_idx;
  sb.state = bit_value ? 1 : 0;
  int rc = ioctl(g_fd, OVC2_IOCTL_SET_BIT, &sb);
  printf("rc = %d\n", rc);
  return 0;
}

int main(int argc, char **argv)
{
  if (argc < 2)
    usage();
  const char *cmd = argv[1];
  g_fd = open(OVC2_DEVICE, O_RDWR);
  if (g_fd < 0) {
    printf("oh noes. couldn't open %s  :(\n", OVC2_DEVICE);
    return 1;
  }
  signal(SIGINT, sigint_handler);
  if (!strcmp(cmd, "set_bit"))
    return set_bit(argc, argv);
  else {
    printf("unknown command: %s\n", cmd);
    usage();
  }
  return 0;
}
