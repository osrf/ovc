#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>
#include <iostream>

#include <ovc_embedded_driver/spi_driver.h>

SPIDriver::SPIDriver(int gpio_uio_num) :
  accel_sens(DEFAULT_ACCEL_SENS), gyro_sens(DEFAULT_GYRO_SENS), uio(UIODriver(gpio_uio_num, GPIO_UIO_SIZE))
{
  spi_fd = open("/dev/spidev1.0", O_RDWR);

  if (spi_fd < 0)
    std::cout << "Failed in opening spi file" << std::endl;

  // Set mode 3, clock idle high
  int mode = SPI_MODE_3;
  ioctl(spi_fd, SPI_IOC_RD_MODE, &mode);
  ioctl(spi_fd, SPI_IOC_WR_MODE, &mode);

  // Set bank
  selectBank(0);
  // Reset
  writeRegister(PWR_MGMT_1, 0x81);
  usleep(5000);
  // Clear sleep
  writeRegister(PWR_MGMT_1, 0x01);
  usleep(5000);
  // Disable I2C
  writeRegister(USER_CTRL, 0x10);

  // Bank 2
  selectBank(2);
  // Set divider
  writeRegister(GYRO_SMPLRT_DIV, 4); // target 225 Hz
  // Accelerometer
  writeRegister(ACCEL_SMPLRT_DIV_2, 4); // target 225 Hz
  // Back to register bank 0
  selectBank(0);
  


  // Read whoami
  unsigned char who_am_i = readRegister(WHO_AM_I);
  if (who_am_i != CHIP_ID)
    std::cout << "WHO_AM_I communication failed" << std::endl;

  // Configure AXI GPIO
  // Enable interrupts on channel 0
  uio.writeRegister(GIER, 1 << 31);
  uio.writeRegister(IER, 1);
  //uio.writeRegister(8, 7); // 7 samples per frame
  // We need to write 3 to ISR register to toggle both (should only be 1?)
  uio.setResetRegisterMask(ISR, 3);
  // Configure interrupt on sample ready
  writeRegister(INT_ENABLE_1, 1);
  std::cout << "IMU Initialization done" << std::endl;
}

void SPIDriver::selectBank(int bank)
{
  writeRegister(REG_BANK_SEL, bank << 4);
}

void SPIDriver::writeRegister(unsigned char addr, unsigned char val)
{
  tx_buf[0] = addr | MASK_WRITE; // bitwise OR essentially NOP
  tx_buf[1] = val;
  Transmit(2,0);
}

unsigned char SPIDriver::readRegister(unsigned char addr)
{
  tx_buf[0] = addr | MASK_READ; 
  Transmit(1,1);
  return rx_buf[0]; 
}

void SPIDriver::burstReadRegister(unsigned char addr, int count)
{
  // TODO check maximum count for burst read
  tx_buf[0] = addr | MASK_READ;
  Transmit(1,count);
}

IMUReading SPIDriver::readSensors()
{
  // Wait for new data available
  uio.waitInterrupt();
  // TODO add temperature / compass?
  IMUReading ret;
  // TODO make high level function for specific uio, maybe inheriting
  ret.num_sample = uio.readRegister(GPIO_DATA);
  tx_buf[0] = ACCEL_XOUT_H | MASK_READ;
  Transmit(1, 12);
  // Cast to make sure we don't lose the sign
  ret.a_x = static_cast<int16_t>(rx_buf[0] << 8 | rx_buf[1]) / accel_sens;
  ret.a_y = static_cast<int16_t>(rx_buf[2] << 8 | rx_buf[3]) / accel_sens;
  ret.a_z = static_cast<int16_t>(rx_buf[4] << 8 | rx_buf[5]) / accel_sens;
  ret.g_x = static_cast<int16_t>(rx_buf[6] << 8 | rx_buf[7]) / gyro_sens;
  ret.g_y = static_cast<int16_t>(rx_buf[8] << 8 | rx_buf[9]) / gyro_sens;
  ret.g_z = static_cast<int16_t>(rx_buf[10] << 8 | rx_buf[11]) / gyro_sens;
  //std::cout << "Got IMU n. " << ret.num_sample << std::endl;
  return ret;
}

void SPIDriver::Transmit(size_t tx_len, size_t rx_len)
{
  struct spi_ioc_transfer xfer[2]; 
  memset(xfer, 0, sizeof xfer);
  xfer[0].tx_buf = (uint64_t) tx_buf;
  xfer[0].len = tx_len;
  xfer[0].speed_hz = 1000000;
  xfer[1].rx_buf = (uint64_t) rx_buf;
  xfer[1].len = rx_len;
  xfer[1].speed_hz = 1000000;
  
  int status = ioctl(spi_fd, SPI_IOC_MESSAGE(2), xfer);
  if (status < 0)
  {
    perror("SPI_IOC_MESSAGE");
    std::cout << "Ioctl failed" << std::endl;
  }
}
