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
struct ovc2_ioctl_read_pio
{
  uint8_t channel;
  uint32_t data;
};
#define OVC2_IOCTL_READ_PIO _IOWR(OVC2_MAGIC, 3, struct ovc2_ioctl_read_pio)

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_bitslip
{
  uint32_t channels;
};
#define OVC2_IOCTL_BITSLIP _IOW(OVC2_MAGIC, 4, struct ovc2_ioctl_bitslip)

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_imu_set_mode
{
  uint32_t mode;
};
#define OVC2_IOCTL_IMU_SET_MODE _IOW(OVC2_MAGIC, 5, struct ovc2_ioctl_imu_set_mode)
#define OVC2_IOCTL_IMU_SET_MODE_IDLE 0
#define OVC2_IOCTL_IMU_SET_MODE_AUTO 1

//////////////////////////////////////////////////////////////////////
struct ovc2_imu_data
{
  uint64_t t_usecs;
  float accel[3];
  float gyro[3];
  float temperature;
  float pressure;
  float quaternion[4];
  float mag_comp[3];
} __attribute__((packed));

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_cam_set_mode
{
  uint32_t mode;
};
#define OVC2_IOCTL_CAM_SET_MODE _IOW(OVC2_MAGIC, 6, struct ovc2_ioctl_cam_set_mode)
#define OVC2_IOCTL_CAM_SET_MODE_IDLE 0
#define OVC2_IOCTL_CAM_SET_MODE_AUTO 1

//////////////////////////////////////////////////////////////////////
#define OVC2_IOCTL_CAM_DMA_BUF_SIZE (1280*1024*2+256*1024)
//////////////////////////////////////////////////////////////////////

struct ovc2_ioctl_set_sync_timing
{
  uint32_t imu_decimation;
};
#define OVC2_IOCTL_SET_SYNC_TIMING _IOW(OVC2_MAGIC, 7, struct ovc2_ioctl_set_sync_timing)

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_set_exposure
{
  uint32_t exposure_usec;
};
#define OVC2_IOCTL_SET_EXPOSURE _IOW(OVC2_MAGIC, 8, struct ovc2_ioctl_set_exposure)

//////////////////////////////////////////////////////////////////////
struct ovc2_ioctl_set_ast_params
{
  uint8_t threshold;
};
#define OVC2_IOCTL_SET_AST_PARAMS _IOW(OVC2_MAGIC, 9, struct ovc2_ioctl_set_ast_params)


//////////////////////////////////////////////////////////////////////
#endif
