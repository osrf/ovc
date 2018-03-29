#include <cstdlib>
#include <cstdio>
#include <cstring>
#include <errno.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <vector>
#include "ovc.h"
#include "ovc_ioctl.h"

OVC::OVC()
: init_complete(false),
  fd(-1), fd_imu(-1),
  dma_buf(NULL),
  exposure_(0.005)
{
  t_prev_offset.tv_sec  = t_offset.tv_sec  = t_prev_imu.tv_sec  = 0;
  t_prev_offset.tv_nsec = t_offset.tv_nsec = t_prev_imu.tv_nsec = 0;
}

OVC::~OVC()
{
  if (init_complete)
  {
    close(fd);
    close(fd_imu);
    munmap(dma_buf, OVC_IOCTL_DMA_BUF_SIZE);
  }
}

bool OVC::init()
{
  fd = open("/dev/ovc", O_RDWR);
  if (fd < 0) {
    printf("oh noes, couldn't open /dev/ovc\n");
    return false;
  }

  fd_imu = open("/dev/ovc_imu", O_RDWR);
  if (fd_imu < 0) {
    printf("oh noes, couldn't open /dev/ovc_imu\n");
    return false;
  }

  if (!pio_set(0, true))  // enable imager output clock
    return false;
  usleep(10000);

  if (!pio_set(3, true))  // assert imager reset
    return false;
  usleep(10000);

  if (!pio_set(3, false))  // de-assert imager reset
    return false;
  usleep(50000);  // wait for imagers to wake up again

  if (!set_corner_threshold(30))
    return false;

  if (!enable_register_ram_paging())
    return false;

  usleep(100);
  if (!configure_imagers())
    return false;

  if (!configure_imu())
    return false;

  dma_buf = (uint8_t *)mmap(
    0, OVC_IOCTL_DMA_BUF_SIZE, PROT_READ, MAP_SHARED, fd, 0);
  if (dma_buf == MAP_FAILED) {
    printf("oh noes, mmap failed: %s\n", strerror(errno));
    return false;
  }

  if (!set_sync_timing(7))
    return false;

  if (!set_exposure(0.005)) {
    printf("couldn't set exposure :(\n");
    return false;
  }

  if (!estimate_timestamp_offset()) {
    printf("OVC::estimate_timestamp_offset() failed :(\n");
    return false;
  }

  printf("OVC init successful.\n");

  init_complete = true;
  return true;
}

bool OVC::configure_imu()
{
  struct ovc_ioctl_imu_txrx imu_txrx;
  int rc = 0;

  // set auto-poll to idle
  struct ovc_ioctl_imu_set_mode imu_set_mode;
  imu_set_mode.mode = OVC_IOCTL_IMU_SET_MODE_IDLE;
  rc = ioctl(fd, OVC_IOCTL_IMU_SET_MODE, &imu_set_mode);
  if (rc) {
    printf("unexpected rc from ioctl set mode: %d\n", rc);
    return rc;
  }


  // first, reset it...
  pio_set(2, true);  // assert imu reset pin
  usleep(1000);
  pio_set(2, false);  // de-assert imu reset pin
  printf("waiting 2 seconds for IMU reset...\n");
  usleep(2000000);  // wait 2 seconds

  // disable async output
  imu_txrx.dir = OVC_IOCTL_IMU_TXRX_DIR_WRITE;
  imu_txrx.len = 8;
  imu_txrx.reg_idx = 6;  // synchronization control
  memset(imu_txrx.buf, 0, sizeof(imu_txrx.buf));
  // setting this register bytes 0-3 to zero will turn off async output
  imu_txrx.buf[4] = 1;  // serial port 1
  rc = ioctl(fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected imu ioctl rc: %d\n", rc);
    return false;
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
  rc = ioctl(fd, OVC_IOCTL_IMU_TXRX, &imu_txrx);
  if (rc) {
    printf("unexpected imu ioctl rc: %d\n", rc);
    return false;
  }
  printf("IMU configured successfully.\n");

  // set auto-poll back to auto
  imu_set_mode.mode = OVC_IOCTL_IMU_SET_MODE_AUTO;
  rc = ioctl(fd, OVC_IOCTL_IMU_SET_MODE, &imu_set_mode);
  if (rc) {
    printf("unexpected rc from ioctl set mode: %d\n", rc);
    return rc;
  }
  printf("IMU auto-poll started.\n");
  return true;
}

bool OVC::pio_set(int pio_idx, bool state)
{
  //printf("pio_set(%d, %s)\n", pio_idx, state ? "on": "off");
  struct ovc_pio_set pio_set;
  pio_set.pio_idx = pio_idx;
  pio_set.pio_state = state ? 1 : 0;
  int rc = ioctl(fd, OVC_IOCTL_PIO_SET, &pio_set);
  if (rc) {
    printf("unexpected return from pio_set ioctl call: %d\n", rc);
    return false;
  }
  return true;
}

bool OVC::enable_register_ram_paging()
{
  printf("enable_register_ram_paging()\n");
  struct ovc_ioctl_enable_reg_ram enable;
  enable.enable = 1;
  int rc = ioctl(fd, OVC_IOCTL_ENABLE_REG_RAM, &enable);
  if (rc) {
    printf("unexpected return from enable_reg_ram ioctl call: %d\n", rc);
    return false;
  }
  return true;
}

// save some typing...
#define ADD_REG(idx,val) regs.push_back(ImagerRegister(idx, val))

bool OVC::configure_imager(int i)
{
  std::vector<ImagerRegister> regs;

  if (i != 0 && i != 1) {
    printf("invalid imager index: %d\n", i);
    return false;
  }

  ADD_REG(32, 0x4008);  // enable logic clock
  ADD_REG(20, 0x0001);  // enable LVDS clock input
  ADD_REG( 9, 0x0000);  // release clkgen soft-reset
  ADD_REG(32, 0x400a);  // enable logic clock
  ADD_REG(34, 0x0001);  // enable logic blocks

  // magic register settings... don't ask questions.
  ADD_REG( 41, 0x08aa);
  ADD_REG( 42, 0x4110);
  ADD_REG( 43, 0x0008);
  ADD_REG( 65, 0x382b);
  ADD_REG( 66, 0x53c8);  // bias current
  ADD_REG( 67, 0x0665);
  ADD_REG( 68, 0x0088);  // lvds comm+diff level
  ADD_REG( 70, 0x1111);
  ADD_REG( 72, 0x0017);
  ADD_REG(128, 0x4714);
  ADD_REG(129, 0xa001);  // 8-bit mode
  ADD_REG(171, 0x1002);
  ADD_REG(175, 0x0080);
  ADD_REG(176, 0x00e6);
  ADD_REG(177, 0x0400);

  //ADD_REG(192, 0x100c);  // sequencer general config: master mode
  ADD_REG(192, 0x103c);  // sequencer general config: slave mode
  ADD_REG(194, 0x0224);  // integration_control
  ADD_REG(197, 0x0306);  // black_lines
  ADD_REG(204, 0x01e1);  // set gain to 1.0
  ADD_REG(207, 0x0000);  // ref_lines
  ADD_REG(211, 0x0e49);
  ADD_REG(215, 0x111f);
  ADD_REG(216, 0x7f00);
  ADD_REG(219, 0x0020);
  ADD_REG(220, 0x3a28);
  ADD_REG(221, 0x624d);
  ADD_REG(222, 0x624d);
  ADD_REG(224, 0x3e5e);
  ADD_REG(227, 0x0000);
  ADD_REG(250, 0x2081);
  ADD_REG(384, 0xc800);
  ADD_REG(384, 0xC800);
  ADD_REG(385, 0xFB1F);
  ADD_REG(386, 0xFB1F);
  ADD_REG(387, 0xFB12);
  ADD_REG(388, 0xF903);
  ADD_REG(389, 0xF802);
  ADD_REG(390, 0xF30F);
  ADD_REG(391, 0xF30F);
  ADD_REG(392, 0xF30F);
  ADD_REG(393, 0xF30A);
  ADD_REG(394, 0xF101);
  ADD_REG(395, 0xF00A);
  ADD_REG(396, 0xF24B);
  ADD_REG(397, 0xF226);
  ADD_REG(398, 0xF001);
  ADD_REG(399, 0xF402);
  ADD_REG(400, 0xF001);
  ADD_REG(401, 0xF402);
  ADD_REG(402, 0xF001);
  ADD_REG(403, 0xF401);
  ADD_REG(404, 0xF007);
  ADD_REG(405, 0xF20F);
  ADD_REG(406, 0xF20F);
  ADD_REG(407, 0xF202);
  ADD_REG(408, 0xF006);
  ADD_REG(409, 0xEC02);
  ADD_REG(410, 0xE801);
  ADD_REG(411, 0xEC02);
  ADD_REG(412, 0xE801);
  ADD_REG(413, 0xEC02);
  ADD_REG(414, 0xC801);
  ADD_REG(415, 0xC800);
  ADD_REG(416, 0xC800);
  ADD_REG(417, 0xCC02);
  ADD_REG(418, 0xC801);
  ADD_REG(419, 0xCC02);
  ADD_REG(420, 0xC801);
  ADD_REG(421, 0xCC02);
  ADD_REG(422, 0xC805);
  ADD_REG(423, 0xC800);
  ADD_REG(424, 0x0030);
  ADD_REG(425, 0x207C);
  ADD_REG(426, 0x2071);
  ADD_REG(427, 0x0074);
  ADD_REG(428, 0x107F);
  ADD_REG(429, 0x1072);
  ADD_REG(430, 0x1074);
  ADD_REG(431, 0x0076);
  ADD_REG(432, 0x0031);
  ADD_REG(433, 0x21BB);
  ADD_REG(434, 0x20B1);
  ADD_REG(435, 0x20B1);
  ADD_REG(436, 0x00B1);
  ADD_REG(437, 0x10BF);
  ADD_REG(438, 0x10B2);
  ADD_REG(439, 0x10B4);
  ADD_REG(440, 0x00B1);
  ADD_REG(441, 0x0030);
  ADD_REG(442, 0x0030);
  ADD_REG(443, 0x217B);
  ADD_REG(444, 0x2071);
  ADD_REG(445, 0x2071);
  ADD_REG(446, 0x0074);
  ADD_REG(447, 0x107F);
  ADD_REG(448, 0x1072);
  ADD_REG(449, 0x1074);
  ADD_REG(450, 0x0076);
  ADD_REG(451, 0x0031);
  ADD_REG(452, 0x20BB);
  ADD_REG(453, 0x20B1);
  ADD_REG(454, 0x20B1);
  ADD_REG(455, 0x00B1);
  ADD_REG(456, 0x10BF);
  ADD_REG(457, 0x10B2);
  ADD_REG(458, 0x10B4);
  ADD_REG(459, 0x00B1);
  ADD_REG(460, 0x0030);
  ADD_REG(461, 0x0030);
  ADD_REG(462, 0x207C);
  ADD_REG(463, 0x2071);
  ADD_REG(464, 0x0073);
  ADD_REG(465, 0x017A);
  ADD_REG(466, 0x0078);
  ADD_REG(467, 0x1074);
  ADD_REG(468, 0x0076);
  ADD_REG(469, 0x0031);
  ADD_REG(470, 0x21BB);
  ADD_REG(471, 0x20B1);
  ADD_REG(472, 0x20B1);
  ADD_REG(473, 0x00B1);
  ADD_REG(474, 0x10BF);
  ADD_REG(475, 0x10B2);
  ADD_REG(476, 0x10B4);
  ADD_REG(477, 0x00B1);
  ADD_REG(478, 0x0030);
  ADD_REG(206, 0x077f);

	// soft power up
  ADD_REG(32 , 0x400b);  // enable analog clock
  ADD_REG(10 , 0x0000);  // release soft reset
  ADD_REG(64 , 0x0001);  // enable biasing block
  ADD_REG(72 , 0x0017);  // enable charge pump
  ADD_REG(40 , 0x0003);  // enable col. multiplexer
  ADD_REG(42 , 0x4113);  // configure image core
  ADD_REG(48 , 0x0001);  // enable analog front-end
  ADD_REG(112, 0x0007);  // enable LVDS transmitters

  // set exposure to 5 ms
  // NOTE: this is not used anymore with external trigger (slave mode) enabled,
  // which is driven by the FPGA timing
	ADD_REG(199, 32);  // set mult_timer to 128
  int ticks = (int)(0.005 / (128.0 / 250.0e6));  // 9765 for 5ms
  ADD_REG(201, (uint16_t)ticks);

  ADD_REG(192, 0x103d);  // enable sequencer in slave mode

  // now blast through and actually set all those registers
  for (auto &r: regs)
    if (!write_imager_reg(i, r))
      return false;

  return true;
}

bool OVC::configure_imagers()
{
  for (int i = 0; i < 2; i++) {
    // make sure we can read the WHOAMI register
    ImagerRegister whoami(0, 0);
    if (!read_imager_reg(i, whoami)) {
      printf("oh no, couldn't read WHOAMI from imager %d\n", i);
      return false;
    }
    printf("imager %d WHOAMI = 0x%04x\n", i, (unsigned)whoami.value);
    if (whoami.value != 0x50d0) {
      printf("that's bad.\n");
      return false;
    }

    if (!configure_imager(i)) {
      printf("oh no, couldn't configure imager %d\n", i);
      return false;

    }
    if (!align_imager_lvds(i)) {
      printf("oh no, couldn't align LVDS stream of imager %d\n", i);
      return false;
    }
    printf("imager %d configured successfully\n", i);
  }
  return true;
}

bool OVC::read_imager_reg(const uint8_t imager_idx, ImagerRegister &reg)
{
  if (imager_idx > 1)
    return false;  // get outta here
  struct ovc_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC_IOCTL_SPI_XFER_DIR_READ;
  spi_xfer.bus = imager_idx;
  spi_xfer.reg_addr = reg.index;
  spi_xfer.reg_val = 0;
  int rc = ioctl(fd, OVC_IOCTL_SPI_XFER, &spi_xfer);
  if (rc != 0) {
    printf("oh no! error reading imager %d register %d\n",
      (int)imager_idx, (int)reg.index);
    return false;
  }
  reg.value = spi_xfer.reg_val;
  return true;
}

bool OVC::write_imager_reg(const uint8_t imager_idx, const ImagerRegister reg)
{
  struct ovc_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC_IOCTL_SPI_XFER_DIR_WRITE;
  spi_xfer.bus = imager_idx;
  spi_xfer.reg_addr = reg.index;
  spi_xfer.reg_val = reg.value;
  int rc = ioctl(fd, OVC_IOCTL_SPI_XFER, &spi_xfer);
  if (rc != 0) {
    printf("oh no! error setting spi register %d to 0x%04x\n",
      (int)reg.index, (unsigned)reg.value);
    return false;
  }

  return true;
}

bool OVC::align_imager_lvds(const int imager_idx)
{
  if (imager_idx != 0 && imager_idx != 1) {
    printf("invalid imager index passed to OVC::align_imager_lvds: %d\n", imager_idx);
    return false;
  }
  // first we need to align the sync channel
  struct ovc_ioctl_read_data read_data;
  read_data.camera = (uint8_t)imager_idx;  // TODO: use this parameter in the kernel
  read_data.channel = imager_idx * 4;
  uint8_t sync_data = 0;
  bool sync_ok = false;
  int bitslips = 0, zeros = 0;
  for (int attempt = 0; attempt < 1000; attempt++) {
    int rc = ioctl(fd, OVC_IOCTL_READ_DATA, &read_data);
    if (rc) {
      printf("oh noes, weird RC when reading data: %d\n", rc);
      return false;
    }
    sync_data = (uint8_t)(read_data.data >> 24);
    if (sync_data == 0x00) {
      zeros++;
      continue;  // this word isn't informative...
    }
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
      bitslips++;
      printf("bitslip(0x%02x) saw 0x%02x on imager %d sync lane\n",
        (unsigned)bs.channels, (unsigned)sync_data, imager_idx);
      int rc = ioctl(fd, OVC_IOCTL_BITSLIP, &bs);
      if (rc) {
        printf("oh noes, weird rc from bitslip ioctl: %d\n", rc);
        return false;
      }
      usleep(100);  // wait for the bitslip to bang through all the widgets
    }
    else {
      sync_ok = true;
      break;
    }
  }
  if (!sync_ok) {
    printf("oh noes, couldn't align sync channel :(\n");
    printf("saw %d zeros\n", zeros);
    return false;
  }
  printf("sync channel aligned successfully after %d rotations\n", bitslips);
  for (int channel = 0; channel < 4; channel++) {
    read_data.channel = channel + imager_idx * 4;
    bool channel_ok = false;
    bitslips = 0;
    for (int attempt = 0; attempt < 10000; attempt++) {
      ioctl(fd, OVC_IOCTL_READ_DATA, &read_data);
      ioctl(fd, OVC_IOCTL_READ_DATA, &read_data);  // why twice?
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
        bitslips++;
        int rc = ioctl(fd, OVC_IOCTL_BITSLIP, &bs);
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
    printf("imager %d channel %d aligned successfully after %d rotations\n",
      imager_idx, channel, bitslips);
  }

  printf("all LVDS links on imager %d aligned successfully\n", imager_idx);
  return true;
}

bool OVC::wait_for_image(uint8_t **p, struct timespec &t)
{
  struct ovc_ioctl_dma_start dma_start;
  dma_start.len = OVC_IOCTL_DMA_BUF_SIZE / 128;  //20608;
  dma_start.offset = 0x00;
  int rc = ioctl(fd, OVC_IOCTL_DMA_START, &dma_start);
  //printf("ioctl rc = %d\n", rc);
  if (rc) {
    printf("oh no, bad rc from dma_start ioctl: %d\n", rc);
    return false;
  }

  // every second, re-slew the onboard timestamps to system time
  // to deal with clock drift. At some point we can get smarter
  // and speed/slow the onboard clock, if it becomes an issue.
  static double t_prev_poll = 0;
  double t_poll = ros::Time::now().toSec();
  if (t_poll - t_prev_poll > 1.0) {
    estimate_timestamp_offset();
    t_prev_poll = t_poll;
  }

  int dummy = 0;
  int read_rc = read(fd, &dummy, sizeof(int));
  if (read_rc < 0)
    return false;  // bogus
    
  *p = dma_buf;  // todo: rotate around DMA buffer ring

  uint32_t *meta = (uint32_t *)(&dma_buf[1280*1024*2]);
  uint32_t t_hw_low = meta[3];
  uint32_t t_hw_high = meta[4];
  uint64_t t_hw = ((uint64_t)t_hw_high << 32) | t_hw_low;

  // t_hw is in microseconds. we need to add that to the t_offset
  hardware_time_to_system_time(t_hw, t);

  /*
  for (int i = 0; i < 1024; i++) {
    printf("%02x ", dma[i]);
    if (i % 16 == 15)
      printf("\n");
  }
  FILE *f = fopen("img.bin", "wb");
  fwrite(dma, 1, 1280*1024, f);
  fclose(f);
  printf("wrote image dump file\n");
  */
  return true;
}

bool OVC::set_sync_timing(const uint8_t imu_decimation)
{
  printf("set_sync_timing(%d)\n", (int)imu_decimation);
  struct ovc_ioctl_set_sync_timing timing;
  timing.imu_decimation = imu_decimation;
  int rc = ioctl(fd, OVC_IOCTL_SET_SYNC_TIMING, &timing);
  if (rc) {
    printf("unexpected return from set_sync_timing ioctl call: %d\n", rc);
    return false;
  }
  return true;
}

bool OVC::set_exposure(float seconds)
{
  //printf("set_exposure(%0.6f)\n", seconds);
  if (seconds > 0.065)
    seconds = 0.065;
  struct ovc_ioctl_set_exposure set_exposure;
  set_exposure.exposure_usec = seconds * 1000000;
  exposure_ = seconds;
  int rc = ioctl(fd, OVC_IOCTL_SET_EXPOSURE, &set_exposure);
  if (rc) {
    printf("unexpected return from set_exposure ioctl call: %d\n", rc);
    return false;
  }
  return true;
}

// lightly edited from the original implementation available here:
// https://github.com/panzi/CRC-and-checksum-functions/blob/master/crc_32.c

static uint32_t g_crc_32_tab[] = { /* CRC polynomial 0xedb88320 */
0x00000000, 0x77073096, 0xee0e612c, 0x990951ba, 0x076dc419, 0x706af48f,
0xe963a535, 0x9e6495a3, 0x0edb8832, 0x79dcb8a4, 0xe0d5e91e, 0x97d2d988,
0x09b64c2b, 0x7eb17cbd, 0xe7b82d07, 0x90bf1d91, 0x1db71064, 0x6ab020f2,
0xf3b97148, 0x84be41de, 0x1adad47d, 0x6ddde4eb, 0xf4d4b551, 0x83d385c7,
0x136c9856, 0x646ba8c0, 0xfd62f97a, 0x8a65c9ec, 0x14015c4f, 0x63066cd9,
0xfa0f3d63, 0x8d080df5, 0x3b6e20c8, 0x4c69105e, 0xd56041e4, 0xa2677172,
0x3c03e4d1, 0x4b04d447, 0xd20d85fd, 0xa50ab56b, 0x35b5a8fa, 0x42b2986c,
0xdbbbc9d6, 0xacbcf940, 0x32d86ce3, 0x45df5c75, 0xdcd60dcf, 0xabd13d59,
0x26d930ac, 0x51de003a, 0xc8d75180, 0xbfd06116, 0x21b4f4b5, 0x56b3c423,
0xcfba9599, 0xb8bda50f, 0x2802b89e, 0x5f058808, 0xc60cd9b2, 0xb10be924,
0x2f6f7c87, 0x58684c11, 0xc1611dab, 0xb6662d3d, 0x76dc4190, 0x01db7106,
0x98d220bc, 0xefd5102a, 0x71b18589, 0x06b6b51f, 0x9fbfe4a5, 0xe8b8d433,
0x7807c9a2, 0x0f00f934, 0x9609a88e, 0xe10e9818, 0x7f6a0dbb, 0x086d3d2d,
0x91646c97, 0xe6635c01, 0x6b6b51f4, 0x1c6c6162, 0x856530d8, 0xf262004e,
0x6c0695ed, 0x1b01a57b, 0x8208f4c1, 0xf50fc457, 0x65b0d9c6, 0x12b7e950,
0x8bbeb8ea, 0xfcb9887c, 0x62dd1ddf, 0x15da2d49, 0x8cd37cf3, 0xfbd44c65,
0x4db26158, 0x3ab551ce, 0xa3bc0074, 0xd4bb30e2, 0x4adfa541, 0x3dd895d7,
0xa4d1c46d, 0xd3d6f4fb, 0x4369e96a, 0x346ed9fc, 0xad678846, 0xda60b8d0,
0x44042d73, 0x33031de5, 0xaa0a4c5f, 0xdd0d7cc9, 0x5005713c, 0x270241aa,
0xbe0b1010, 0xc90c2086, 0x5768b525, 0x206f85b3, 0xb966d409, 0xce61e49f,
0x5edef90e, 0x29d9c998, 0xb0d09822, 0xc7d7a8b4, 0x59b33d17, 0x2eb40d81,
0xb7bd5c3b, 0xc0ba6cad, 0xedb88320, 0x9abfb3b6, 0x03b6e20c, 0x74b1d29a,
0xead54739, 0x9dd277af, 0x04db2615, 0x73dc1683, 0xe3630b12, 0x94643b84,
0x0d6d6a3e, 0x7a6a5aa8, 0xe40ecf0b, 0x9309ff9d, 0x0a00ae27, 0x7d079eb1,
0xf00f9344, 0x8708a3d2, 0x1e01f268, 0x6906c2fe, 0xf762575d, 0x806567cb,
0x196c3671, 0x6e6b06e7, 0xfed41b76, 0x89d32be0, 0x10da7a5a, 0x67dd4acc,
0xf9b9df6f, 0x8ebeeff9, 0x17b7be43, 0x60b08ed5, 0xd6d6a3e8, 0xa1d1937e,
0x38d8c2c4, 0x4fdff252, 0xd1bb67f1, 0xa6bc5767, 0x3fb506dd, 0x48b2364b,
0xd80d2bda, 0xaf0a1b4c, 0x36034af6, 0x41047a60, 0xdf60efc3, 0xa867df55,
0x316e8eef, 0x4669be79, 0xcb61b38c, 0xbc66831a, 0x256fd2a0, 0x5268e236,
0xcc0c7795, 0xbb0b4703, 0x220216b9, 0x5505262f, 0xc5ba3bbe, 0xb2bd0b28,
0x2bb45a92, 0x5cb36a04, 0xc2d7ffa7, 0xb5d0cf31, 0x2cd99e8b, 0x5bdeae1d,
0x9b64c2b0, 0xec63f226, 0x756aa39c, 0x026d930a, 0x9c0906a9, 0xeb0e363f,
0x72076785, 0x05005713, 0x95bf4a82, 0xe2b87a14, 0x7bb12bae, 0x0cb61b38,
0x92d28e9b, 0xe5d5be0d, 0x7cdcefb7, 0x0bdbdf21, 0x86d3d2d4, 0xf1d4e242,
0x68ddb3f8, 0x1fda836e, 0x81be16cd, 0xf6b9265b, 0x6fb077e1, 0x18b74777,
0x88085ae6, 0xff0f6a70, 0x66063bca, 0x11010b5c, 0x8f659eff, 0xf862ae69,
0x616bffd3, 0x166ccf45, 0xa00ae278, 0xd70dd2ee, 0x4e048354, 0x3903b3c2,
0xa7672661, 0xd06016f7, 0x4969474d, 0x3e6e77db, 0xaed16a4a, 0xd9d65adc,
0x40df0b66, 0x37d83bf0, 0xa9bcae53, 0xdebb9ec5, 0x47b2cf7f, 0x30b5ffe9,
0xbdbdf21c, 0xcabac28a, 0x53b39330, 0x24b4a3a6, 0xbad03605, 0xcdd70693,
0x54de5729, 0x23d967bf, 0xb3667a2e, 0xc4614ab8, 0x5d681b02, 0x2a6f2b94,
0xb40bbe37, 0xc30c8ea1, 0x5a05df1b, 0x2d02ef8d
};

bool OVC::validate_signature(
  const uint8_t *img, const uint32_t len, const uint32_t *sig)
{
	uint32_t crc = 0x12345678;  //0x78563412;  // 0x12345678; //0xffffffff;
  int n = 0;
  for (const uint8_t *p = img; p < img + len; p += 4) {
    const uint8_t b =  (*(p+0)) ^ (*(p+1)) ^ (*(p+2)) ^ (*(p+3));
    crc = g_crc_32_tab[((crc) ^ ((uint8_t)b)) & 0xff] ^ ((crc) >> 8);
    n++;
    //printf("b = 0x%02x  after %d words: 0x%08x\n", b, n, (unsigned)~crc);
  }
  crc = ~crc;

  bool ok = *sig == crc;
  if (!ok)
    printf("image signature mismatch!  rx: 0x%08x   calc: 0x%08x\n",
      (unsigned)*sig, crc);
  return ok;
}

bool OVC::wait_for_imu_state(OVCIMUState &imu_state, struct timespec &t)
{
  int dummy = 0;
  int read_rc = read(fd_imu, &dummy, sizeof(int));
  if (read_rc < 0)
    return false;  // bogus

  // now there is a new IMU packet for us to go pick up
 
  struct ovc_ioctl_imu_read imu_read;
  int rc = ioctl(fd, OVC_IOCTL_IMU_READ, &imu_read);
  if (rc) {
    printf("unexpected return from set_exposure ioctl call: %d\n", rc);
    return false;
  }
  uint64_t t_imu_hwtime = imu_read.t_usecs;
  struct timespec t_test;
  hardware_time_to_system_time(t_imu_hwtime, t_test);

  // make sure t_test - t_prev_imu is sane
  double t_test_s = t_test.tv_sec + (double)t_test.tv_nsec / 1.0e9;
  double t_prev_imu_s = t_prev_imu.tv_sec + (double)t_prev_imu.tv_nsec / 1.0e9;
  double t_test_dt = t_test_s - t_prev_imu_s;

  if (t_prev_imu_s == 0 || (t_test_dt > 0 && t_test_dt < 0.5)) {
    t = t_test;  // use the calculated system_time + hardware offset
  }
  else {
    // the image thread changed the time offset while we were polling the IMU.
    // "Fix it" by estimating the IMU time of this sample to be 1 period
    // after the previous IMU time, rather than using the hardware timestamp
    // NOTE: the IMU is hard-coded to 200 Hz output in OVC::configure_imu()

    uint64_t dt_imu_usecs_est = 1000000000/200;  // 5 million nanoseconds
    uint64_t nsec_sum = t_prev_imu.tv_nsec + dt_imu_usecs_est;
    uint64_t nsec_mod = nsec_sum % 1000000000;
    t.tv_nsec = nsec_mod;
    t.tv_sec = t_prev_imu.tv_sec + (nsec_sum - nsec_mod) / 1000000000;

    //double t_corrected = t.tv_sec + (double)t.tv_nsec / 1.0e9;
    //double dt_corrected = t_corrected - t_prev_imu_s;
    //printf("dt_calc = %.3f t_test = %.3f  t_prev = %.3f dt_corr = %.3f\n",
    //    t_test_dt, t_test_s, t_prev_imu_s, dt_corrected);
  }
  // save timestamp for next iteration
  t_prev_imu = t;

  // for now, just copy over the IMU data fields.
  // Maybe in the future we'll swap stuff around or whatever.
  for (int i = 0; i < 3; i++) {
    imu_state.accel[i] = imu_read.accel[i];
    imu_state.gyro[i] = imu_read.gyro[i];
    imu_state.mag_comp[i] = imu_read.mag_comp[i];
  }
  for (int i = 0; i < 4; i++)
    imu_state.quaternion[i] = imu_read.quaternion[i];
  imu_state.temperature = imu_read.temperature;
  imu_state.pressure = imu_read.pressure;
  return true;
}

bool OVC::update_autoexposure_loop(uint8_t *image)
{
  if (!image)
    return false;  // wut
  // todo: move this image-sum calculation into the FPGA
  const uint32_t PIXEL_SKIP = 23;  // skip ahead a prime number of pixels
  uint32_t sum = 0;
  for (int i = 0; i < 1280*1024; i += PIXEL_SKIP)
    sum += image[i];
  const double current_brightness = sum / (double)(1280*1024/PIXEL_SKIP);
  const double target_brightness = 100;  // target average pixel value
  double new_exposure = exposure_ * target_brightness / current_brightness;
  // clamp to sane values
  if (new_exposure < 10e-6)
    new_exposure = 10e-6;
  else if (new_exposure > 10e-3)
    new_exposure = 10e-3;

  // slow down motion to the target a bit to avoid flicker
  // could be smarter, but for now just crank through an exponential filter
  const double alpha = 0.3;
  double filtered_exposure = alpha * new_exposure + (1.0 - alpha) * exposure_;

  //printf("new_exposure = %0.6f\n", new_exposure);
  return set_exposure(filtered_exposure);
}

bool OVC::set_corner_threshold(const uint8_t threshold)
{
  struct ovc_ioctl_set_ast_params ast;
  ast.threshold = threshold;
  int rc = ioctl(fd, OVC_IOCTL_SET_AST_PARAMS, &ast);
  if (rc) {
    printf("unexpected return from set_ast_params ioctl call: %d\n", rc);
    return false;
  }
  return true;
}

bool OVC::estimate_timestamp_offset()
{
  if (!pio_set(9, true))  // assert timestamp-reset
    return false;
  if (!pio_set(9, false))  // de-assert timestamp-reset
    return false;
  t_prev_offset.tv_sec = t_offset.tv_sec;
  t_prev_offset.tv_nsec = t_offset.tv_nsec;
  // poll system time. Use that as the offset.
  if (0 != clock_gettime(CLOCK_REALTIME, &t_offset)) {
    printf("oh no, clock_gettime() returned an error :(\n");
    return false;
  }
  return true;
}

void OVC::hardware_time_to_system_time(
  const uint64_t t_hw, struct timespec &t_out)
{
  uint64_t nsec_sum = t_offset.tv_nsec + t_hw * 1000;
  uint64_t nsec_mod = nsec_sum % 1000000000;
  t_out.tv_nsec = nsec_mod;
  t_out.tv_sec = t_offset.tv_sec + (nsec_sum - nsec_mod) / 1000000000;
}
