#include <cstdio>
#include <cstdlib>
#include <fcntl.h>
#include <sys/ioctl.h>  // ioctl
#include <sys/mman.h>   // mmap
#include <unistd.h>
#include "ovc2.h"
#include "../modules/ovc2_core/ovc2_ioctl.h"

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

bool OVC2::set_bit(int reg_idx, int bit_idx, bool bit_value)
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

int OVC2::spi_read(int bus, int reg)
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

