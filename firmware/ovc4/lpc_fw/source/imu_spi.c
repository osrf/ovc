#include "fsl_pint.h"
#include "fsl_inputmux.h"

#include "ovc_hw_defs.h"
#include "imu_spi.h"

volatile static uint32_t interrupt_flag = 0;

static void gpio_intr_callback(pint_pin_int_t pintr, uint32_t pmatch_status)
{
  interrupt_flag |= (1 << pintr);
}

void imuspi_init(SPI_Type *base, IMUSPI* imu_spi)
{
  imu_spi->base_ = base;
  spi_master_config_t spi_config = {0}; 

  /*
   * userConfig.enableLoopback = false;
   * userConfig.enableMaster = true;
   * userConfig.polarity = kSPI_ClockPolarityActiveHigh;
   * userConfig.phase = kSPI_ClockPhaseFirstEdge;
   * userConfig.direction = kSPI_MsbFirst;
   * userConfig.baudRate_Bps = 500000U;
   */

  // TODO more configurability?
  SPI_MasterGetDefaultConfig(&spi_config);
  spi_config.sselNum = IMU_SPI_SS_NUM;
  spi_config.sselPol = IMU_SPI_SPOL;
  spi_config.baudRate_Bps = IMU_SPI_BAUD;
  SPI_MasterInit(base, &spi_config, SPI_CLOCK_FREQUENCY);
}

void icm42688_init(SPI_Type *base, ICMIMU* imu)
{
  // Init the structure to default full scale outputs
  imu->gyro_range_ = (1.0 / 32768) * 4000 * DEG_TO_RAD; // 4000 dps for 42686 TODO change to 2000 for 42688
  imu->acc_range_ = (1.0 / 32768) * 32 * G_TO_METERS; // 32 g for 42686 TODO change to 16 g for 42688
  // TODO consider polling WHO_AM_I register
  // TODO do we need to reset first?
  imuspi_init(base, &imu->spi);
  // Start by resetting
  uint8_t reset_val = 1;
  icm42688_write_register(imu, ICM42688_DEVICE_CONFIG_REGADDR, reset_val);
  for (volatile int tmp = 0; tmp < 50000; ++tmp);
  reset_val = 0;
  icm42688_write_register(imu, ICM42688_DEVICE_CONFIG_REGADDR, reset_val);
  // Remove reset
  uint8_t regval = 0 |
    0x3 | // Maximum accuracy for accelerometer
    0xC;// Maximum accuracy for gyroscope
  icm42688_write_register(imu, ICM42688_PWR_MGMT0_REGADDR, regval);
  // Datasheet says not to write anything for at least 200us
  // TODO proper sleep function
  // >= 333 us at 150MHz
  for (volatile int tmp = 0; tmp < 50000; ++tmp);
  // Set interrupt to push-pull, active high
  regval = 0x3;
  icm42688_write_register(imu, ICM42688_INT_CONFIG_REGADDR, regval);
  // Datasheet says to write 0 for proper interrupt operation
  regval = 0;
  icm42688_write_register(imu, ICM42688_INT_CONFIG1_REGADDR, regval);
  // Enable interrupt on data ready
  regval = 0x8;
  icm42688_write_register(imu, ICM42688_INT_SOURCE0_REGADDR, regval);
  // Try to read whoami
  icm42688_read_register(imu, ICM42688_WHO_AM_I_REGADDR);

}

void icm42688_read_sensor_data(ICMIMU* imu, usb_tx_packet_t* tx_packet)
{
  // The first byte is for the address
  uint8_t rx_buf[1 + ICM42688_DATA_LENGTH];
  uint8_t tx_buf[1 + ICM42688_DATA_LENGTH] = {0};
  tx_buf[0] = ICM42688_TEMP_DATA1_REGADDR | ICM42688_READ_MASK;
  imuspi_full_duplex(&imu->spi, tx_buf, rx_buf, sizeof(rx_buf));
  tx_packet->packet_type = TX_PACKET_TYPE_IMU;
  // Now fill the structure, order is accel x,y,z, gyro x,y,z, MSB - LSB for each
  // Twos complement int16_t
  int16_t values[ICM42688_DATA_LENGTH / 2];
  for (int i=0; i< ICM42688_DATA_LENGTH / 2; ++i)
  {
    values[i] = ((int16_t)rx_buf[1 + (2 * i)] << 8) | rx_buf[1 + (2 * i) + 1];
  }
  // Fill data
  // Temperature formula from datasheet
  tx_packet->imu.temperature = (float)values[0] / 132.48 + 25;
  tx_packet->imu.acc_x = (float)values[1] * imu->acc_range_;
  tx_packet->imu.acc_y = (float)values[2] * imu->acc_range_;
  tx_packet->imu.acc_z = (float)values[3] * imu->acc_range_;
  tx_packet->imu.gyro_x = (float)values[4] * imu->gyro_range_;
  tx_packet->imu.gyro_y = (float)values[5] * imu->gyro_range_;
  tx_packet->imu.gyro_z = (float)values[6] * imu->gyro_range_;
}

// ICM has 8 bit register addresses and 8 bit register values
void icm42688_write_register(ICMIMU* imu, uint8_t reg_addr, uint8_t data)
{
  uint8_t tx_data[2] = {reg_addr, data};
  imuspi_transmit_data(&imu->spi, tx_data, sizeof(tx_data));
}

uint8_t icm42688_read_register(ICMIMU* imu, uint8_t reg_addr)
{
  uint8_t tx_data[2] = {reg_addr | ICM42688_READ_MASK, 0};
  uint8_t rx_data;
  imuspi_full_duplex(&imu->spi, tx_data, &rx_data, sizeof(tx_data));
  return rx_data;
}

void imuspi_transmit_data(IMUSPI* imu_spi, uint8_t* tx_data, uint8_t tx_size)
{
  spi_transfer_t xfer = {0};
  xfer.txData = tx_data;
  xfer.dataSize = tx_size;
  // TODO check configFlags
  xfer.configFlags = kSPI_FrameAssert;
  // TODO check if NULL for rxData is OK
  SPI_MasterTransferBlocking(imu_spi->base_, &xfer);
}

void imuspi_receive_data(IMUSPI* imu_spi, uint8_t* rx_data, uint8_t rx_size)
{
  spi_transfer_t xfer = {0};
  xfer.rxData = rx_data;
  xfer.dataSize = rx_size;
  // TODO check configFlags
  xfer.configFlags = kSPI_FrameAssert;
  // TODO check if NULL for txData is OK
  SPI_MasterTransferBlocking(imu_spi->base_, &xfer);
}

void imuspi_full_duplex(IMUSPI* imu_spi, uint8_t* tx_data, uint8_t* rx_data, uint8_t size)
{
  spi_transfer_t xfer = {0};
  xfer.rxData = rx_data;
  xfer.txData = tx_data;
  xfer.dataSize = size;
  // TODO check configFlags
  xfer.configFlags = kSPI_FrameAssert;
  SPI_MasterTransferBlocking(imu_spi->base_, &xfer);
}

void imuspi_attach_interrupt(IMUSPI* imu_spi)
{
  static uint32_t attached_interrupts = 0;
  pint_pin_int_t pint_intr = kPINT_PinInt0 + attached_interrupts;

  INPUTMUX_Init(INPUTMUX);
  INPUTMUX_AttachSignal(INPUTMUX, pint_intr, IMU_INT_GPIO_PINT); 
  INPUTMUX_Deinit(INPUTMUX);
  
  PINT_Init(PINT);
  PINT_PinInterruptConfig(PINT, pint_intr, kPINT_PinIntEnableRiseEdge, gpio_intr_callback);
  PINT_EnableCallbackByIndex(PINT, pint_intr);

  imu_spi->interrupt_mask_ = 1u << attached_interrupts;
  ++attached_interrupts;
}

bool imuspi_check_interrupt(IMUSPI* imu_spi)
{
  if (interrupt_flag & imu_spi->interrupt_mask_)
  {
    interrupt_flag &= (~imu_spi->interrupt_mask_);
    return true;
  }
  return false;
}
