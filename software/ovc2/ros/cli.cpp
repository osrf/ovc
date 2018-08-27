#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <signal.h>
#include "ovc2.h"
using ovc2::OVC2;

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
  printf("    configure_imagers\n");
  printf("    align_imager_lvds\n");
  printf("    configure_imu\n");
  printf("    read_imu\n");
  printf("    stream_imu\n");
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

int configure_imagers(OVC2 *ovc2)
{
  if (!ovc2->configure_imagers())
    return 1;
  return 0;
}

int align_imager_lvds(OVC2 *ovc2)
{
  for (int i = 0; i < 2; i++)
    if (!ovc2->align_imager_lvds(i))
      return 1;
  return 0;
}

int configure_imu(OVC2 *ovc2)
{
  if (!ovc2->configure_imu())
    return 1;
  return 0;
}

int read_imu(OVC2 *ovc2)
{
  return ovc2->wait_for_imu_data(true) ? 0 : 1;
}

int stream_imu(OVC2 *ovc2)
{
  while (!g_done) {
    if (!ovc2->wait_for_imu_data())
      break;
    struct ovc2_imu_data *i = &ovc2->imu_data_;
    printf("\n\n");
    printf("t_usecs = %llu\n", (long long unsigned)i->t_usecs);
    printf("accel = %+.3f  %+.3f  %+.3f\n",
      i->accel[0], i->accel[1], i->accel[2]);
    printf("gyro  = %+.3f  %+.3f  %+.3f\n",
      i->gyro[0], i->gyro[1], i->gyro[2]);
    printf("temp  = %+.3f\n", i->temperature);
    printf("pressure = %+.3f\n", i->pressure);
    printf("quat = %+.3f  %+.3f  %+.3f  %+.3f\n",
      i->quaternion[0], i->quaternion[1],
      i->quaternion[2], i->quaternion[3]);
    printf("mag = %+.3f  %+.3f  %+.3f\n",
      i->mag_comp[0], i->mag_comp[1], i->mag_comp[2]);
  }
  return 0;
}

int read_image(OVC2 *ovc2)
{
  FILE *f = fopen("test.bin", "w");
  bool written = false;
  uint8_t *img = NULL;
  struct timespec t;
  while (!g_done) {
    if (!ovc2->wait_for_image(&img, t)) {
      printf("error in wait_for_image()\n");
      return 1;
    }
    printf("read successful\n");
    if (!written) {
      fwrite(img, 1, 1280*1024*2, f);
      written = true;
    }
    for (int r = 0; r < 1024; r += 32) {
      for (int c = 0; c < 1280; c += 16) {
        printf("%01x", (unsigned)(img[r*1280+c] / 16));
      }
      printf("\n");
    }
    uint32_t corners[2] = {0};
    corners[0] = *((uint32_t *)&img[1280*1024*2+ 8]);
    corners[1] = *((uint32_t *)&img[1280*1024*2+12]);
    printf("corners: %06d %06d\n", (int)corners[0], (int)corners[1]);
  }
  fclose(f);
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
  else if (!strcmp(cmd, "configure_imagers"))
    return configure_imagers(&ovc2);
  else if (!strcmp(cmd, "align_imager_lvds"))
    return align_imager_lvds(&ovc2);
  else if (!strcmp(cmd, "configure_imu"))
    return configure_imu(&ovc2);
  else if (!strcmp(cmd, "read_imu"))
    return read_imu(&ovc2);
  else if (!strcmp(cmd, "stream_imu"))
    return stream_imu(&ovc2);
  else if (!strcmp(cmd, "read_image"))
    return read_image(&ovc2);
  else {
    printf("unknown command: %s\n", cmd);
    usage();
  }
  return 0;
}
