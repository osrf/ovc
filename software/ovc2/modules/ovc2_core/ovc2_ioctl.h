#ifndef OVC2_CORE_IOCTL_H
#define OVC2_CORE_IOCTL_H

#include <linux/ioctl.h>

#ifndef __KERNEL__
#include <stdint.h>
#endif

// not sure what this should be...
#define OVC2_MAGIC 98

struct ovc2_ioctl_set_bit
{
  uint32_t reg_idx;
  uint8_t bit_idx;
  uint8_t state;
};

#define OVC2_IOCTL_SET_BIT _IOW(OVC2_MAGIC, 0, struct ovc2_ioctl_set_bit)
#define OVC2_REG_PCIE_PIO 0

#endif
