#include "fsl_pint.h"
#include "fsl_inputmux.h"

#include "ovc_hw_defs.h"
#include "imu_spi.h"

volatile static uint32_t interrupt_flag = 0;
volatile bool int_bool = false;

static void gpio_intr_callback(pint_pin_int_t pintr, uint32_t pmatch_status)
{
  interrupt_flag |= (1 << pintr);
  int_bool = true;
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
  PINT_PinInterruptConfig(PINT, pint_intr, kPINT_PinIntEnableFallEdge, gpio_intr_callback);
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
