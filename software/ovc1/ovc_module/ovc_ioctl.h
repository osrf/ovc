#ifndef OVC_IOCTL_H
#define OVC_IOCTL_H

#include <linux/ioctl.h>

#ifndef __KERNEL__
#include <stdint.h>
#endif

// not sure about the restrictions for this number...
#define OVC_MAGIC 99

struct ovc_pio_set
{
  uint8_t pio_idx;
  uint8_t pio_state;
};

#define OVC_IOCTL_PIO_SET _IOW(OVC_MAGIC, 0, struct ovc_pio_set)

struct ovc_ioctl_spi_xfer
{
  uint8_t bus;
  uint8_t dir;  // 0 = read, 1 = write
  uint16_t reg_addr;
  uint16_t reg_val;
};

#define OVC_IOCTL_SPI_XFER_DIR_READ  0
#define OVC_IOCTL_SPI_XFER_DIR_WRITE 1

#define OVC_IOCTL_SPI_XFER _IOWR(OVC_MAGIC, 1, struct ovc_ioctl_spi_xfer)

struct ovc_ioctl_dma_start
{
  uint32_t len;
  uint32_t offset;
};

#define OVC_IOCTL_DMA_START _IOWR(OVC_MAGIC, 2, struct ovc_ioctl_dma_start)
#define OVC_IOCTL_DMA_BUF_SIZE (1280*1024*2+256*1024)

struct ovc_ioctl_read_data
{
  uint8_t camera;
  uint8_t channel;
  uint32_t data;
};

#define OVC_IOCTL_READ_DATA _IOWR(OVC_MAGIC, 3, struct ovc_ioctl_read_data)

struct ovc_ioctl_bitslip
{
  uint32_t channels;
};
#define OVC_IOCTL_BITSLIP _IOW(OVC_MAGIC, 4, struct ovc_ioctl_bitslip)

#define OVC_IOCTL_IMU_TXRX_BUF_LEN 60
struct ovc_ioctl_imu_txrx
{
  uint8_t dir;
  uint8_t len;
  uint8_t reg_idx;
  uint8_t dummy;
  uint8_t buf[OVC_IOCTL_IMU_TXRX_BUF_LEN];
} __attribute__((packed));
#define OVC_IOCTL_IMU_TXRX _IOWR(OVC_MAGIC, 5, struct ovc_ioctl_imu_txrx)
#define OVC_IOCTL_IMU_TXRX_DIR_READ  0
#define OVC_IOCTL_IMU_TXRX_DIR_WRITE 1

struct ovc_ioctl_imu_set_mode
{
  uint8_t mode;
} __attribute__((packed));
#define OVC_IOCTL_IMU_SET_MODE _IOWR(OVC_MAGIC, 7, struct ovc_ioctl_imu_set_mode)
#define OVC_IOCTL_IMU_SET_MODE_IDLE 0
#define OVC_IOCTL_IMU_SET_MODE_AUTO 1

struct ovc_ioctl_imu_read
{
  uint64_t t_usecs;  // system time (microseconds since powerup)
  float accel[3];
  float gyro[3];
  float temperature;
  float pressure;
  float quaternion[4];
  float mag_comp[3];
} __attribute__((packed));
#define OVC_IOCTL_IMU_READ _IOWR(OVC_MAGIC, 8, struct ovc_ioctl_imu_read)

struct ovc_ioctl_enable_reg_ram
{
  uint8_t enable;
} __attribute__((packed));
#define OVC_IOCTL_ENABLE_REG_RAM _IOWR(OVC_MAGIC, 9, struct ovc_ioctl_enable_reg_ram)

struct ovc_ioctl_set_sync_timing
{
  uint8_t imu_decimation;
} __attribute__((packed));
#define OVC_IOCTL_SET_SYNC_TIMING _IOWR(OVC_MAGIC, 10, struct ovc_ioctl_set_sync_timing)

struct ovc_ioctl_set_exposure
{
  uint32_t exposure_usec;
} __attribute__((packed));
#define OVC_IOCTL_SET_EXPOSURE _IOWR(OVC_MAGIC, 11, struct ovc_ioctl_set_exposure)

struct ovc_ioctl_set_ast_params
{
  uint8_t threshold;
} __attribute__((packed));
#define OVC_IOCTL_SET_AST_PARAMS _IOWR(OVC_MAGIC, 12, struct ovc_ioctl_set_ast_params)

#endif
