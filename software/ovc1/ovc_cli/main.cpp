#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fcntl.h>  // open
#include <sys/ioctl.h>  // ioctl
#include <sys/mman.h>  // mmap
#include <signal.h>
#include <unistd.h>
#include "../ovc_module/ovc_ioctl.h"

int g_fd = 0;

bool g_done = false;
void sigint_handler(int signum)
{
  g_done = true;
}


void usage()
{
  printf("usage:  ovc_cli COMMAND [ARGUMENTS]\n");
  printf("  available commands:\n");
  printf("    pio_set IDX VAL\n");
  printf("    spi_read BUS REG\n");
  printf("    spi_write BUS REG VAL\n");
  printf("    configure_imagers\n");
  printf("    dma_test\n");
  printf("    read_data CHANNEL\n");
  printf("    bitslip CHANNEL\n");
  printf("    align\n");
  printf("    imu_read REG LEN\n");
  printf("    imu_configure\n");
  printf("    imu_stream\n");
  printf("    enable_reg_ram\n");
  printf("\n");
  exit(1);
}

int enable_reg_ram()
{
  struct ovc_ioctl_enable_reg_ram enable;
  enable.enable = 1;
  int rc = ioctl(g_fd, OVC_IOCTL_ENABLE_REG_RAM, &enable);
  printf("rc = %d\n", rc);
  return rc;
}

int spi_read(int argc, char **argv)
{
  if (argc < 4)
    usage();
  int bus = atoi(argv[2]);
  int reg = atoi(argv[3]);
  printf("spi_read(%d, %d)\n", bus, reg);
  struct ovc_ioctl_spi_xfer spi_xfer;  // __attribute__((aligned(16)));
  spi_xfer.dir = OVC_IOCTL_SPI_XFER_DIR_READ;
  spi_xfer.bus = bus;
  spi_xfer.reg_addr = reg;
  spi_xfer.reg_val = 0;
  int rc = ioctl(g_fd, OVC_IOCTL_SPI_XFER, &spi_xfer);
  printf("val = 0x%04x    rc = %d\n", (unsigned)spi_xfer.reg_val, rc);
  return 0;
}

int imu_read(int argc, char **argv)
{
  //printf("    imu_read REG LEN\n");
  if (argc < 4)
    usage();
  int reg = atoi(argv[2]);
  int len = atoi(argv[3]);
  printf("imu_read from register %d length %d\n", reg, len);
  struct ovc_ioctl_imu_txrx imu_txrx;
  imu_txrx.dir = OVC_IOCTL_IMU_TXRX_DIR_READ;
  imu_txrx.len = len;
  imu_txrx.reg_idx = reg;
  memset(imu_txrx.buf, 0, sizeof(imu_txrx.buf));
  int rc = ioctl(g_fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected rc: %d\n", rc);
    return rc;
  }
  for (int i = 0; i < len; i++)
    printf("%3d: 0x%02x\n", i, (unsigned)imu_txrx.buf[i]);
  printf("as int: %d\n", *((int32_t *)imu_txrx.buf));
  return 0;
}

int imu_configure()
{
  printf("imu_configure()\n");
  struct ovc_ioctl_imu_txrx imu_txrx;
  int rc = 0;
  /*
  // for now, just set the port to 115200 to show we can do something
  imu_txrx.dir = OVC_IOCTL_IMU_TXRX_DIR_WRITE;
  imu_txrx.len = 8;
  imu_txrx.reg_idx = 5;  // set baud rate
  memset(imu_txrx.buf, 0, sizeof(imu_txrx.buf));
  *((uint32_t *)(&imu_txrx.buf[0])) = 115200;
  int rc = ioctl(g_fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected rc: %d\n", rc);
    return rc;
  }
  */
  // disable async output
  imu_txrx.dir = OVC_IOCTL_IMU_TXRX_DIR_WRITE;
  imu_txrx.len = 8;
  imu_txrx.reg_idx = 6;  // synchronization control
  memset(imu_txrx.buf, 0, sizeof(imu_txrx.buf));
  // setting this register bytes 0-3 to zero will turn off async output
  imu_txrx.buf[4] = 1;  // serial port 1
  rc = ioctl(g_fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected ioctl rc: %d\n", rc);
    return rc;
  }

  // configure sync pins
  imu_txrx.dir = OVC_IOCTL_IMU_TXRX_DIR_WRITE;
  imu_txrx.len = 20;
  imu_txrx.reg_idx = 32;  // synchronization control
  memset(imu_txrx.buf, 0, sizeof(imu_txrx.buf));
  imu_txrx.buf[0] = 3;  // only count sync_in pulses, don't do anything else
  imu_txrx.buf[8] = 3;  // assert SYNC_OUT when attitude measurements are there
  imu_txrx.buf[9] = 1;  // positive-pulse on SYNC_OUT
  *((uint16_t *)(&imu_txrx.buf[10])) = 1;  // sync_out skip factor: 1 = 200 Hz
  *((uint32_t *)(&imu_txrx.buf[12])) = 100000;  // request 100 us pulse width
  rc = ioctl(g_fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected rc: %d\n", rc);
    return rc;
  }

  return 0;
}

int imu_stream()
{
  struct ovc_ioctl_imu_txrx imu_txrx;
  int rc = 0;
  // for debugging, slow it waaaaaaay down
  imu_txrx.dir = OVC_IOCTL_IMU_TXRX_DIR_WRITE;
  imu_txrx.len = 20;
  imu_txrx.reg_idx = 32;  // synchronization control
  memset(imu_txrx.buf, 0, sizeof(imu_txrx.buf));
  imu_txrx.buf[0] = 3;  // only count sync_in pulses, don't do anything else
  imu_txrx.buf[8] = 3;  // assert SYNC_OUT when attitude measurements are there
  imu_txrx.buf[9] = 1;  // positive-pulse on SYNC_OUT
  *((uint16_t *)(&imu_txrx.buf[10])) = 1;  // generate 200 syncs per second
  *((uint32_t *)(&imu_txrx.buf[12])) = 100000;  // request 100 us pulse width
  rc = ioctl(g_fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected rc: %d\n", rc);
    return rc;
  }

  struct ovc_ioctl_imu_set_mode imu_set_mode;
  imu_set_mode.mode = OVC_IOCTL_IMU_SET_MODE_AUTO;
  rc = ioctl(g_fd, OVC_IOCTL_IMU_SET_MODE, &imu_set_mode);
  if (rc) {
    printf("unexpected rc from ioctl set mode: %d\n", rc);
    return rc;
  }

  FILE *f = fopen("imu.txt", "w");
  printf("spinning... press Ctrl+C to stop...\n");
  while (!g_done) {
    usleep(10000);
    struct ovc_ioctl_imu_read imu_data;
    rc = ioctl(g_fd, OVC_IOCTL_IMU_READ, &imu_data);
    if (rc) {
      printf("unexpected rc from ioctl imu read: %d\n", rc);
      return rc;
    }
    fprintf(f, "%+7.3f %+7.3f %+7.3f %+7.3f %+7.3f %+7.3f "
      "%+7.3f %+7.3f %+7.3f %+7.3f "
      "%+7.6f %+7.6f %+7.6f "
      "%+7.3f %+7.3f\n",
      imu_data.accel[0], imu_data.accel[1], imu_data.accel[2],
      imu_data.gyro[0], imu_data.gyro[1], imu_data.gyro[2],
      imu_data.quaternion[0],
      imu_data.quaternion[1],
      imu_data.quaternion[2],
      imu_data.quaternion[3],
      imu_data.mag_comp[0], imu_data.mag_comp[1], imu_data.mag_comp[2],
      imu_data.pressure, imu_data.temperature);
      
    printf("==============\n");
    printf("accel: %.3f %.3f %.3f\n",
      imu_data.accel[0], imu_data.accel[1], imu_data.accel[2]);
    printf("gyro : %.3f %.3f %.3f\n",
      imu_data.gyro[0], imu_data.gyro[1], imu_data.gyro[2]);
    printf("quat : %.3f %.3f %.3f %.3f\n",
      imu_data.quaternion[0],
      imu_data.quaternion[1],
      imu_data.quaternion[2],
      imu_data.quaternion[3]);
    printf("mag  : %.3f %.3f %.3f\n",
      imu_data.mag_comp[0], imu_data.mag_comp[1], imu_data.mag_comp[2]);
    printf("pressure: %.3f\n", imu_data.pressure);
    printf("temperature: %.3f\n", imu_data.temperature);
  }
  fclose(f);

  printf("returning IMU SPI interface back to Linux host...\n");
  imu_set_mode.mode = OVC_IOCTL_IMU_SET_MODE_IDLE;
  rc = ioctl(g_fd, OVC_IOCTL_IMU_SET_MODE, &imu_set_mode);
  if (rc) {
    printf("unexpected rc from ioctl set mode: %d\n", rc);
    return rc;
  }
  printf("done.\n");

  return 0;
}

int spi_write(int argc, char **argv)
{
  if (argc < 5)
    usage();
  int bus = atoi(argv[2]);
  int reg = atoi(argv[3]);
  int val = atoi(argv[4]);
  printf("spi_write(%d, %d, %d)\n", bus, reg, val);
  struct ovc_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC_IOCTL_SPI_XFER_DIR_WRITE;
  spi_xfer.bus = bus;
  spi_xfer.reg_addr = reg;
  spi_xfer.reg_val = val;
  int rc = ioctl(g_fd, OVC_IOCTL_SPI_XFER, &spi_xfer);
  printf("rc = %d\n", rc);
  return 0;
}

int dma_test(int argc, char **argv)
{
  //int dma_fd = open("/dev/ovc", O_RDONLY);
  uint8_t *dma = (uint8_t *)mmap(
    0, OVC_IOCTL_DMA_BUF_SIZE, PROT_READ, MAP_SHARED, g_fd, 0);
  printf("g_fd = %d, dma_ptr = %llx\n", g_fd, (unsigned long long)dma);

  struct ovc_ioctl_dma_start dma_start;
  dma_start.len = OVC_IOCTL_DMA_BUF_SIZE / 128;  //20608;
  dma_start.offset = 0x00;
  int rc = ioctl(g_fd, OVC_IOCTL_DMA_START, &dma_start);
  printf("ioctl rc = %d\n", rc);
  usleep(500000);
  for (int i = 0; i < 1024; i++) {
    printf("%02x ", dma[i]);
    if (i % 16 == 15)
      printf("\n");
  }
  FILE *f = fopen("img.bin", "wb");
  fwrite(dma, 1, 1280*1024, f);
  fclose(f);
  printf("wrote image dump file\n");
  return 0;
}

int read_data(int argc, char **argv)
{
  if (argc < 3)
    usage();
  struct ovc_ioctl_read_data read_data;
  read_data.camera = 0;
  read_data.channel = atoi(argv[2]);
  uint8_t prev_sync_data = 0;
  int nread = 0;
  while (nread < 10) {
    int rc = ioctl(g_fd, OVC_IOCTL_READ_DATA, &read_data);
    uint8_t sync_data = (uint8_t)(read_data.data >> 24);
    if (sync_data != prev_sync_data) {
      nread++;
      prev_sync_data = sync_data;
      uint8_t channel_data = (uint8_t)(read_data.data >> 16);
      printf("sync: 0x%02x channel %d: 0x%02x\n",
        (unsigned)sync_data, (int)read_data.channel, (unsigned)channel_data);
    }
  }
  return 0;
}

int align()
{
  // first we need to align the sync channel
  struct ovc_ioctl_read_data read_data;
  read_data.camera = 0;
  read_data.channel = 0;
  for (int imager_idx = 0; imager_idx < 2; imager_idx++) {
    printf("working on imager %d\n", imager_idx);
    read_data.channel = imager_idx * 4;
    uint8_t sync_data = 0;
    bool sync_ok = false;
    for (int attempt = 0; attempt < 100; attempt++) {
      int rc = ioctl(g_fd, OVC_IOCTL_READ_DATA, &read_data);
      sync_data = (uint8_t)(read_data.data >> 24);
      if (sync_data == 0x00)
        continue;  // this word isn't informative...
      if (sync_data != 0x0d &&
          sync_data != 0x0a &&
          sync_data != 0xe9 &&
          sync_data != 0xaa &&
          sync_data != 0xca &&
          sync_data != 0x4a &&
          sync_data != 0x16 &&
          sync_data != 0x05)
      {
        // we need to bitslip the sync channel
        struct ovc_ioctl_bitslip bs;
        bs.channels = (imager_idx == 0 ? 0x10 : 0x200);  // only sync lane
        printf("bitslip(0x%02x)  saw 0x%02x on imager %d sync lane\n",
          (unsigned)bs.channels, (unsigned)sync_data, imager_idx);
        int rc = ioctl(g_fd, OVC_IOCTL_BITSLIP, &bs);
        if (rc) {
          printf("oh noes, weird rc from bitslip ioctl: %d\n", rc);
          return 1;
        }
        usleep(100);  // wait for the bitslip to bang through all the widgets
      }
      else {
        sync_ok = true;
        printf("sync channel OK: 0x%02x\n", sync_data);
        break;
      }
    }
    if (!sync_ok) {
      printf("oh noes, couldn't align sync channel :(\n");
      return 1;
    }
    printf("sync channel aligned OK\n");
    for (int channel = 0; channel < 4; channel++) {
      read_data.channel = channel + imager_idx * 4;
      bool channel_ok = false;
      for (int attempt = 0; attempt < 10000; attempt++) {
        ioctl(g_fd, OVC_IOCTL_READ_DATA, &read_data);
        ioctl(g_fd, OVC_IOCTL_READ_DATA, &read_data);
        sync_data = (uint8_t)(read_data.data >> 24);
        if (sync_data == 0xe9) {
          //printf("found sync word\n");
          uint8_t channel_data = (uint8_t)(read_data.data >> 16);
          if (channel_data == 0xe9) {
            channel_ok = true;
            break;
          }
          // channel data wasn't the training word 0xe9, so let's shift it
          struct ovc_ioctl_bitslip bs;
          bs.channels = 1 << (channel + imager_idx * 5);
          printf("imager %d lane %d: found 0x%02x. bitslip(0x%02x)\n",
            (int)imager_idx, channel,
            (unsigned)channel_data, (unsigned)bs.channels);
          int rc = ioctl(g_fd, OVC_IOCTL_BITSLIP, &bs);
          if (rc) {
            printf("oh noes, weird rc from bitslip ioctl: %d\n", rc);
            return 1;
          }
          usleep(100);  // wait for the bitslip to bang through all the widgets
        }
      }
      if (!channel_ok) {
        printf("oh noes, couldn't align channel %d\n", channel);
        return 1;
      }
      printf("channel %d aligned OK\n", channel);
    }
  }
  return 0;
}

int bitslip(int argc, char **argv)
{
  if (argc < 3)
    usage();
  struct ovc_ioctl_bitslip bs;
  bs.channels = atoi(argv[2]);
  printf("bitslip(%d)\n", (int)bs.channels);
  int rc = ioctl(g_fd, OVC_IOCTL_BITSLIP, &bs);
  printf("rc = %d\n", rc);
  return 0;
}

int pio_set(int argc, char **argv)
{
  if (argc < 4)
    usage();
  int index = atoi(argv[2]);
  int value = atoi(argv[3]);
  printf("pio_set(%d, %d)\n", index, value);
  struct ovc_pio_set pio_set;
  pio_set.pio_idx = index;
  pio_set.pio_state = value;
  int rc = ioctl(g_fd, OVC_IOCTL_PIO_SET, &pio_set);
  printf("rc = %d\n", rc);
  return 0;
}

bool write_imager_reg(
  const uint8_t imager_idx,
  const uint32_t reg_idx,
  const uint32_t reg_val)
{
  struct ovc_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC_IOCTL_SPI_XFER_DIR_WRITE;
  spi_xfer.bus = imager_idx;
  spi_xfer.reg_addr = reg_idx;
  spi_xfer.reg_val = reg_val;
  int rc = ioctl(g_fd, OVC_IOCTL_SPI_XFER, &spi_xfer);
  if (rc != 0) {
    printf("oh no! error setting spi register %d to 0x%04x\n",
      (int)reg_idx, (unsigned)reg_val);
    return false;
  }
  return true;
}

bool configure_imager(const uint8_t i)
{
  if (!write_imager_reg(i,  32, 0x4008)) return false; // enable logic clock
  if (!write_imager_reg(i,  20, 0x0001)) return false; // enable LVDS clock input
  if (!write_imager_reg(i,   9, 0x0000)) return false; // release clkgen soft-reset
  if (!write_imager_reg(i,  32, 0x400a)) return false; // enable logic clock
  if (!write_imager_reg(i,  34, 0x0001)) return false; // enable logic blocks

  // magic register settings... don't ask questions.
  if (!write_imager_reg(i,  41, 0x08aa)) return false;
  if (!write_imager_reg(i,  42, 0x4110)) return false;
  if (!write_imager_reg(i,  43, 0x0008)) return false;
  if (!write_imager_reg(i,  65, 0x382b)) return false;
  if (!write_imager_reg(i,  66, 0x53c8)) return false;  // bias current
  if (!write_imager_reg(i,  67, 0x0665)) return false;
  if (!write_imager_reg(i,  68, 0x0088)) return false;  // lvds comm+diff level
  if (!write_imager_reg(i,  70, 0x1111)) return false;
  if (!write_imager_reg(i,  72, 0x0017)) return false;
  if (!write_imager_reg(i, 128, 0x4714)) return false;
  if (!write_imager_reg(i, 129, 0xa001)) return false;  // 8-bit mode
  if (!write_imager_reg(i, 171, 0x1002)) return false;
  if (!write_imager_reg(i, 175, 0x0080)) return false;
  if (!write_imager_reg(i, 176, 0x00e6)) return false;
  if (!write_imager_reg(i, 177, 0x0400)) return false;
  //if (!write_imager_reg(0, 192, 0x103c)) return 1;
  if (!write_imager_reg(i, 192, 0x100c)) return false;  // sequencer general config
  if (!write_imager_reg(i, 194, 0x0224)) return false;  // integration_control
  if (!write_imager_reg(i, 197, 0x0306)) return false;  // black_lines
  if (!write_imager_reg(i, 204, 0x01e1)) return false;  // set gain to 1.0
  if (!write_imager_reg(i, 207, 0x0000)) return false;  // ref_lines
  if (!write_imager_reg(i, 211, 0x0e49)) return false;
  if (!write_imager_reg(i, 215, 0x111f)) return false;
  if (!write_imager_reg(i, 216, 0x7f00)) return false;
  if (!write_imager_reg(i, 219, 0x0020)) return false;
  if (!write_imager_reg(i, 220, 0x3a28)) return false;
  if (!write_imager_reg(i, 221, 0x624d)) return false;
  if (!write_imager_reg(i, 222, 0x624d)) return false;
  if (!write_imager_reg(i, 224, 0x3e5e)) return false;
  if (!write_imager_reg(i, 227, 0x0000)) return false;
  if (!write_imager_reg(i, 250, 0x2081)) return false;
  if (!write_imager_reg(i, 384, 0xc800)) return false;
  if (!write_imager_reg(i, 384, 0xC800)) return false;
  if (!write_imager_reg(i, 385, 0xFB1F)) return false;
  if (!write_imager_reg(i, 386, 0xFB1F)) return false;
  if (!write_imager_reg(i, 387, 0xFB12)) return false;
  if (!write_imager_reg(i, 388, 0xF903)) return false;
  if (!write_imager_reg(i, 389, 0xF802)) return false;
  if (!write_imager_reg(i, 390, 0xF30F)) return false;
  if (!write_imager_reg(i, 391, 0xF30F)) return false;
  if (!write_imager_reg(i, 392, 0xF30F)) return false;
  if (!write_imager_reg(i, 393, 0xF30A)) return false;
  if (!write_imager_reg(i, 394, 0xF101)) return false;
  if (!write_imager_reg(i, 395, 0xF00A)) return false;
  if (!write_imager_reg(i, 396, 0xF24B)) return false;
  if (!write_imager_reg(i, 397, 0xF226)) return false;
  if (!write_imager_reg(i, 398, 0xF001)) return false;
  if (!write_imager_reg(i, 399, 0xF402)) return false;
  if (!write_imager_reg(i, 400, 0xF001)) return false;
  if (!write_imager_reg(i, 401, 0xF402)) return false;
  if (!write_imager_reg(i, 402, 0xF001)) return false;
  if (!write_imager_reg(i, 403, 0xF401)) return false;
  if (!write_imager_reg(i, 404, 0xF007)) return false;
  if (!write_imager_reg(i, 405, 0xF20F)) return false;
  if (!write_imager_reg(i, 406, 0xF20F)) return false;
  if (!write_imager_reg(i, 407, 0xF202)) return false;
  if (!write_imager_reg(i, 408, 0xF006)) return false;
  if (!write_imager_reg(i, 409, 0xEC02)) return false;
  if (!write_imager_reg(i, 410, 0xE801)) return false;
  if (!write_imager_reg(i, 411, 0xEC02)) return false;
  if (!write_imager_reg(i, 412, 0xE801)) return false;
  if (!write_imager_reg(i, 413, 0xEC02)) return false;
  if (!write_imager_reg(i, 414, 0xC801)) return false;
  if (!write_imager_reg(i, 415, 0xC800)) return false;
  if (!write_imager_reg(i, 416, 0xC800)) return false;
  if (!write_imager_reg(i, 417, 0xCC02)) return false;
  if (!write_imager_reg(i, 418, 0xC801)) return false;
  if (!write_imager_reg(i, 419, 0xCC02)) return false;
  if (!write_imager_reg(i, 420, 0xC801)) return false;
  if (!write_imager_reg(i, 421, 0xCC02)) return false;
  if (!write_imager_reg(i, 422, 0xC805)) return false;
  if (!write_imager_reg(i, 423, 0xC800)) return false;
  if (!write_imager_reg(i, 424, 0x0030)) return false;
  if (!write_imager_reg(i, 425, 0x207C)) return false;
  if (!write_imager_reg(i, 426, 0x2071)) return false;
  if (!write_imager_reg(i, 427, 0x0074)) return false;
  if (!write_imager_reg(i, 428, 0x107F)) return false;
  if (!write_imager_reg(i, 429, 0x1072)) return false;
  if (!write_imager_reg(i, 430, 0x1074)) return false;
  if (!write_imager_reg(i, 431, 0x0076)) return false;
  if (!write_imager_reg(i, 432, 0x0031)) return false;
  if (!write_imager_reg(i, 433, 0x21BB)) return false;
  if (!write_imager_reg(i, 434, 0x20B1)) return false;
  if (!write_imager_reg(i, 435, 0x20B1)) return false;
  if (!write_imager_reg(i, 436, 0x00B1)) return false;
  if (!write_imager_reg(i, 437, 0x10BF)) return false;
  if (!write_imager_reg(i, 438, 0x10B2)) return false;
  if (!write_imager_reg(i, 439, 0x10B4)) return false;
  if (!write_imager_reg(i, 440, 0x00B1)) return false;
  if (!write_imager_reg(i, 441, 0x0030)) return false;
  if (!write_imager_reg(i, 442, 0x0030)) return false;
  if (!write_imager_reg(i, 443, 0x217B)) return false;
  if (!write_imager_reg(i, 444, 0x2071)) return false;
  if (!write_imager_reg(i, 445, 0x2071)) return false;
  if (!write_imager_reg(i, 446, 0x0074)) return false;
  if (!write_imager_reg(i, 447, 0x107F)) return false;
  if (!write_imager_reg(i, 448, 0x1072)) return false;
  if (!write_imager_reg(i, 449, 0x1074)) return false;
  if (!write_imager_reg(i, 450, 0x0076)) return false;
  if (!write_imager_reg(i, 451, 0x0031)) return false;
  if (!write_imager_reg(i, 452, 0x20BB)) return false;
  if (!write_imager_reg(i, 453, 0x20B1)) return false;
  if (!write_imager_reg(i, 454, 0x20B1)) return false;
  if (!write_imager_reg(i, 455, 0x00B1)) return false;
  if (!write_imager_reg(i, 456, 0x10BF)) return false;
  if (!write_imager_reg(i, 457, 0x10B2)) return false;
  if (!write_imager_reg(i, 458, 0x10B4)) return false;
  if (!write_imager_reg(i, 459, 0x00B1)) return false;
  if (!write_imager_reg(i, 460, 0x0030)) return false;
  if (!write_imager_reg(i, 461, 0x0030)) return false;
  if (!write_imager_reg(i, 462, 0x207C)) return false;
  if (!write_imager_reg(i, 463, 0x2071)) return false;
  if (!write_imager_reg(i, 464, 0x0073)) return false;
  if (!write_imager_reg(i, 465, 0x017A)) return false;
  if (!write_imager_reg(i, 466, 0x0078)) return false;
  if (!write_imager_reg(i, 467, 0x1074)) return false;
  if (!write_imager_reg(i, 468, 0x0076)) return false;
  if (!write_imager_reg(i, 469, 0x0031)) return false;
  if (!write_imager_reg(i, 470, 0x21BB)) return false;
  if (!write_imager_reg(i, 471, 0x20B1)) return false;
  if (!write_imager_reg(i, 472, 0x20B1)) return false;
  if (!write_imager_reg(i, 473, 0x00B1)) return false;
  if (!write_imager_reg(i, 474, 0x10BF)) return false;
  if (!write_imager_reg(i, 475, 0x10B2)) return false;
  if (!write_imager_reg(i, 476, 0x10B4)) return false;
  if (!write_imager_reg(i, 477, 0x00B1)) return false;
  if (!write_imager_reg(i, 478, 0x0030)) return false;
  if (!write_imager_reg(i, 206, 0x077f)) return false;

	// soft power up
  if (!write_imager_reg(i, 32 , 0x400b)) return false;  // enable analog clock
  if (!write_imager_reg(i, 10 , 0x0000)) return false;  // release soft reset
  if (!write_imager_reg(i, 64 , 0x0001)) return false;  // enable biasing block
  if (!write_imager_reg(i, 72 , 0x0017)) return false;  // enable charge pump
  if (!write_imager_reg(i, 40 , 0x0003)) return false;  // enable col. multiplexer
  if (!write_imager_reg(i, 42 , 0x4113)) return false;  // configure image core
  if (!write_imager_reg(i, 48 , 0x0001)) return false;  // enable analog front-end
  if (!write_imager_reg(i, 112, 0x0007)) return false;  // enable LVDS transmitters

	if (!write_imager_reg(i, 199, 32)) return false;  // set mult_timer to 128
	
  // set exposure to 5 ms
  int ticks = (int)(0.005 / (128.0 / 250.0e6));  // 9765 for 5ms
  if (!write_imager_reg(i, 201, ticks)) return false;

  // enable sequencer
  if (!write_imager_reg(i, 192, 0x100d)) return false;  // enable sequencer

  return true;
}

int configure_imagers()
{
  if (!configure_imager(0)) {
    printf("oh noes, couldn't figure imager 0\n");
    return 1;
  }
  if (!configure_imager(1)) {
    printf("oh noes, couldn't figure imager 0\n");
    return 1;
  }
  return 0;
}

int main(int argc, char **argv)
{
  if (argc < 2)
    usage();
  const char *cmd = argv[1];
  g_fd = open("/dev/ovc", O_RDWR);
  if (g_fd < 0) {
    printf("oh noes. couldn't open /dev/ovc  :(\n");
    return 1;
  }
  signal(SIGINT, sigint_handler);
  if (!strcmp(cmd, "spi_read"))
    return spi_read(argc, argv);
  else if (!strcmp(cmd, "spi_write"))
    return spi_write(argc, argv);
  else if (!strcmp(cmd, "pio_set"))
    return pio_set(argc, argv);
  else if (!strcmp(cmd, "configure_imagers"))
    return configure_imagers();
  else if (!strcmp(cmd, "dma_test"))
    return dma_test(argc, argv);
  else if (!strcmp(cmd, "read_data"))
    return read_data(argc, argv);
  else if (!strcmp(cmd, "bitslip"))
    return bitslip(argc, argv);
  else if (!strcmp(cmd, "align"))
    return align();
  else if (!strcmp(cmd, "imu_read"))
    return imu_read(argc, argv);
  else if (!strcmp(cmd, "imu_configure"))
    return imu_configure();
  else if (!strcmp(cmd, "imu_stream"))
    return imu_stream();
  else if (!strcmp(cmd, "enable_reg_ram"))
    return enable_reg_ram();
  else {
    printf("unknown command: %s\n", cmd);
    usage();
  }
  return 0;
}
