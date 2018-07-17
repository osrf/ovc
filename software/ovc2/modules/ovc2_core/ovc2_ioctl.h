#ifndef OVC2_CORE_IOCTL_H
#define OVC2_CORE_IOCTL_H

#include <linux/ioctl.h>

#ifndef __KERNEL__
#include <stdint.h>
#endif

// not sure what this should be...
#define OVC2_MAGIC 98

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_set_bit
{
  uint32_t reg_idx;
  uint8_t bit_idx;
  uint8_t state;
};

#define OVC2_REG_PCIE_PIO 0

#define OVC2_IOCTL_SET_BIT _IOW(OVC2_MAGIC, 0, struct ovc2_ioctl_set_bit)

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_spi_xfer
{
  uint8_t bus;
  uint8_t dir;
  uint16_t reg_addr;
  uint16_t reg_val;
};

#define OVC2_IOCTL_SPI_XFER_DIR_READ  0
#define OVC2_IOCTL_SPI_XFER_DIR_WRITE 1

#define OVC2_IOCTL_SPI_XFER _IOWR(OVC2_MAGIC, 1, struct ovc2_ioctl_spi_xfer)

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_enable_reg_ram
{
  uint8_t enable;
} __attribute__((packed));
#define OVC2_IOCTL_ENABLE_REG_RAM _IOW(OVC2_MAGIC, 2, struct ovc2_ioctl_enable_reg_ram)

//////////////////////////////////////////////////////////////////////

#endif
