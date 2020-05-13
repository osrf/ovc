#ifndef SPI_DRIVER_H
#define SPI_DRIVER_H 1

#include "fsl_spi.h"

// IMU is NOT interrupt based, transfer calls are blocking
typedef struct IMUSPI
{
  SPI_Type *base_;
  uint32_t interrupt_mask_;
} IMUSPI;

void imuspi_init(SPI_Type *base, IMUSPI* imu_spi);

void imuspi_attach_interrupt(IMUSPI* imu_spi);

void imuspi_transmit_data(IMUSPI* imu_spi, uint8_t* tx_data, uint8_t tx_size);

void imuspi_receive_data(IMUSPI* imu_spi, uint8_t* rx_data, uint8_t rx_size);

void imuspi_full_duplex(IMUSPI* imu_spi, uint8_t* tx_data, uint8_t* rx_data, uint8_t size);

bool imuspi_check_interrupt(IMUSPI* imu_spi);

#endif
