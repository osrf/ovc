#ifndef SPI_DRIVER_H
#define SPI_DRIVER_H 1

#include "fsl_spi.h"

#include "usb_packetdef.h"

// MSB defines read / write
#define ICM42688_READ_MASK 0x80

#define ICM42688_DEVICE_CONFIG_REGADDR 0x11
#define ICM42688_PWR_MGMT0_REGADDR 0x4E
#define ICM42688_INT_CONFIG_REGADDR 0x14
#define ICM42688_TEMP_DATA1_REGADDR 0x1D
#define ICM42688_INT_CONFIG1_REGADDR 0x64
#define ICM42688_INT_SOURCE0_REGADDR 0x65
#define ICM42688_WHO_AM_I_REGADDR 0x75

// 6 dof + 1 temperature, each 2 bytes
#define ICM42688_DATA_LENGTH 14

#define DEG_TO_RAD 0.0174533;
#define G_TO_METERS 9.80665;


// IMU is NOT interrupt based, transfer calls are blocking
typedef struct IMUSPI
{
  SPI_Type *base_;
  uint32_t interrupt_mask_;
} IMUSPI;

typedef struct ICMIMU
{
  IMUSPI spi;
  float gyro_range_;
  float acc_range_;
} ICMIMU;

void imuspi_init(SPI_Type *base, IMUSPI* imu_spi);

void imuspi_attach_interrupt(IMUSPI* imu_spi);

void imuspi_transmit_data(IMUSPI* imu_spi, uint8_t* tx_data, uint8_t tx_size);

void imuspi_receive_data(IMUSPI* imu_spi, uint8_t* rx_data, uint8_t rx_size);

void imuspi_full_duplex(IMUSPI* imu_spi, uint8_t* tx_data, uint8_t* rx_data, uint8_t size);

bool imuspi_check_interrupt(IMUSPI* imu_spi);

// ICM 42688 specific functions
void icm42688_init(SPI_Type *base, ICMIMU* imu);

void icm42688_write_register(ICMIMU* imu_spi, uint8_t reg_addr, uint8_t data);

uint8_t icm42688_read_register(ICMIMU* imu_spi, uint8_t reg_addr);

void icm42688_read_sensor_data(ICMIMU* imu_spi, usb_tx_packet_t* tx_packet);

#endif
