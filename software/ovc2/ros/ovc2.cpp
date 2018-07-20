#include <cstdio>
#include <cstdlib>
#include <vector>

#include <fcntl.h>
#include <sys/ioctl.h>  // ioctl
#include <sys/mman.h>   // mmap
#include <unistd.h>

#include "ovc2.h"
#include "../modules/ovc2_core/ovc2_ioctl.h"

using ovc2::OVC2;

static const char * const OVC2_DEVICE = "/dev/ovc2_core";

OVC2::OVC2()
: init_complete_(false),
  fd_(-1)
{
}

OVC2::~OVC2()
{
  if (init_complete_) {
    close(fd_);
  }
}

bool OVC2::init()
{
  fd_ = open(OVC2_DEVICE, O_RDWR);
  if (fd_ < 0) {
    printf("couldn't open %s\n", OVC2_DEVICE);
    return false;
  }
  if (!enable_reg_ram())
    return false;
  printf("reg ram init complete\n");
  init_complete_ = true;
  return true;
}

bool OVC2::enable_reg_ram()
{
  struct ovc2_ioctl_enable_reg_ram e;
  e.enable = 1;
  int rc = ioctl(fd_, OVC2_IOCTL_ENABLE_REG_RAM, &e);
  if (rc != 0)
    printf("uh oh: enable_reg_ram ioctl rc = %d\n", rc);
  return (rc == 0);
}

bool OVC2::set_bit(const int reg_idx, const int bit_idx, const bool bit_value)
{
  struct ovc2_ioctl_set_bit sb;
  sb.reg_idx = reg_idx;
  sb.bit_idx = bit_idx;
  sb.state = bit_value ? 1 : 0;
  int rc = ioctl(fd_, OVC2_IOCTL_SET_BIT, &sb);
  if (rc != 0)
    printf("OVC2::set_bit() ioctl rc = %d\n", rc);
  return (rc == 0);
}

int OVC2::spi_read(const int bus, const int reg)
{
  struct ovc2_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC2_IOCTL_SPI_XFER_DIR_READ;
  spi_xfer.bus = bus;
  spi_xfer.reg_addr = reg;
  spi_xfer.reg_val = 0;
  int rc = ioctl(fd_, OVC2_IOCTL_SPI_XFER, &spi_xfer);
  if (rc != 0) {
    printf("ovc2 spi_read() ioctl rc = %d\n", rc);
    return rc;
  }
  return spi_xfer.reg_val;
}

bool OVC2::reset_imagers()
{
  if (!set_bit(0, 29, true))  // assert imager resets
    return false;
  usleep(10000);  // wait a bit
  if (!set_bit(0, 29, false))  // de-assert imager resets
    return false;
  usleep(50000);  // wait for imagers to wake back up
  return true;
}

bool OVC2::configure_imagers()
{
  if (!reset_imagers()) {
    printf("OVC2::configure_imagers(): reset_imagers() failed\n");
    return false;
  }
  // TODO: this should be talking to both imagers, but SPI on imager #1
  // is messed up in hardware (for now).
  for (int i = 0; i < 1; i++) {
		if (!configure_imager(i)) {
      printf("OH NO couldn't configure imager %d\n", i);
      return false;
    }
    printf("imager %d configured successfully\n", i);
  }
  return true;
}

// save some typing...
#define ADD_REG(idx,val) regs.push_back(ImagerRegister(idx, val))

bool OVC2::configure_imager(const int imager_idx)
{
  if (imager_idx != 0 && imager_idx != 1)
    return false;
  std::vector<ImagerRegister> regs;

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
    if (!write_imager_reg(imager_idx, r))
      return false;

  return true;
}

bool OVC2::read_imager_reg(const int imager_idx, ImagerRegister &reg)
{
  if (imager_idx != 0 && imager_idx != 1)
    return false;  // get outta here
  struct ovc2_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC2_IOCTL_SPI_XFER_DIR_READ;
  spi_xfer.bus = imager_idx;
  spi_xfer.reg_addr = reg.index;
  spi_xfer.reg_val = 0;
  int rc = ioctl(fd_, OVC2_IOCTL_SPI_XFER, &spi_xfer);
  if (rc != 0) {
    printf("oh no! error reading imager %d register %d\n",
      (int)imager_idx, (int)reg.index);
    return false;
  }
  reg.value = spi_xfer.reg_val;
  return true;
}

bool OVC2::write_imager_reg(const int imager_idx, const ImagerRegister reg)
{
  if (imager_idx != 0 && imager_idx != 1)
    return false;
  struct ovc2_ioctl_spi_xfer spi_xfer;
  spi_xfer.dir = OVC2_IOCTL_SPI_XFER_DIR_WRITE;
  spi_xfer.bus = imager_idx;
  spi_xfer.reg_addr = reg.index;
  spi_xfer.reg_val = reg.value;
  int rc = ioctl(fd_, OVC2_IOCTL_SPI_XFER, &spi_xfer);
  if (rc != 0) {
    printf("oh no! error setting spi register %d to 0x%04x\n",
      (int)reg.index, (unsigned)reg.value);
    return false;
  }

  return true;
}

