#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/spi/spidev.h>
#include <iostream>
#include <fstream>

#include <poll.h>

#include <ovc_embedded_driver/spi_driver.h>

static constexpr float DEG_TO_RAD(0.0174533);
static constexpr float G_TO_METRES(9.80665);

SPIDriver::SPIDriver(int spi_num, int max_speed_hz)
{
  std::string spi_filename("/dev/spidev" + std::to_string(spi_num) + ".0");
  spi_fd = open(spi_filename.c_str(), O_RDWR);

  if (spi_fd < 0)
    std::cout << "Failed in opening spi file" << std::endl;

  // Set mode 3, clock idle high
  int mode = SPI_MODE_3;
  ioctl(spi_fd, SPI_IOC_WR_MAX_SPEED_HZ, &max_speed_hz);
  ioctl(spi_fd, SPI_IOC_WR_MODE, &mode);
}

void SPIDriver::Transmit(size_t tx_len, size_t rx_len)
{
  struct spi_ioc_transfer xfer[2]; 
  memset(xfer, 0, sizeof xfer);
  xfer[0].tx_buf = (uint64_t) tx_buf;
  xfer[0].len = tx_len;
  xfer[1].rx_buf = (uint64_t) rx_buf;
  xfer[1].len = rx_len;
  
  int status = ioctl(spi_fd, SPI_IOC_MESSAGE(2), xfer);
  if (status < 0)
  {
    perror("SPI_IOC_MESSAGE");
    std::cout << "Ioctl failed" << std::endl;
  }
}

ICMDriver::ICMDriver(int spi_num, int gpio_uio_num) : 
  SPIDriver(spi_num, MAX_SPI_SPEED), accel_sens(DEFAULT_ACCEL_SENS), gyro_sens(DEFAULT_GYRO_SENS), uio(UIODriver(gpio_uio_num, GPIO_UIO_SIZE))
{
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
  std::cout << "ICM IMU Initialization done" << std::endl;
}

void ICMDriver::selectBank(int bank)
{
  writeRegister(REG_BANK_SEL, bank << 4);
}

void ICMDriver::writeRegister(unsigned char addr, unsigned char val)
{
  tx_buf[0] = addr | MASK_WRITE; // bitwise OR essentially NOP
  tx_buf[1] = val;
  Transmit(2,0);
}

unsigned char ICMDriver::readRegister(unsigned char addr)
{
  tx_buf[0] = addr | MASK_READ; 
  Transmit(1,1);
  return rx_buf[0]; 
}

void ICMDriver::burstReadRegister(unsigned char addr, int count)
{
  // TODO check maximum count for burst read
  tx_buf[0] = addr | MASK_READ;
  Transmit(1,count);
}

int ICMDriver::getSampleNumber()
{
  // Wait for new data available
  uio.waitInterrupt();
  return uio.readRegister(GPIO_DATA);
}

IMUReading ICMDriver::readSensors()
{
  // TODO add temperature / compass?
  IMUReading ret;
  burstReadRegister(ACCEL_XOUT_H, 12);
  // Cast to make sure we don't lose the sign
  // Linear Accelerations
  ret.a_x = static_cast<int16_t>(rx_buf[0] << 8 | rx_buf[1]) * accel_sens * G_TO_METRES;
  ret.a_y = static_cast<int16_t>(rx_buf[2] << 8 | rx_buf[3]) * accel_sens * G_TO_METRES;
  ret.a_z = static_cast<int16_t>(rx_buf[4] << 8 | rx_buf[5]) * accel_sens * G_TO_METRES;
  // Angular velocities
  ret.g_x = static_cast<int16_t>(rx_buf[6] << 8 | rx_buf[7]) * gyro_sens * DEG_TO_RAD;
  ret.g_y = static_cast<int16_t>(rx_buf[8] << 8 | rx_buf[9]) * gyro_sens * DEG_TO_RAD;
  ret.g_z = static_cast<int16_t>(rx_buf[10] << 8 | rx_buf[11]) * gyro_sens * DEG_TO_RAD;
  return ret;
}

VNAVDriver::VNAVDriver(int spi_num, int gpio_num) : SPIDriver(spi_num, MAX_SPI_SPEED)
{
  std::string gpio_str(std::to_string(gpio_num));
  std::string gpio_path = "/sys/class/gpio/gpio" + gpio_str + "/";
  // Export GPIO
  std::ofstream export_fd("/sys/class/gpio/export");
  export_fd << gpio_str;
  export_fd.close();
  // Interrupt on falling edge
  std::ofstream edge_fd(gpio_path + "edge");
  edge_fd << "falling";
  edge_fd.close();
  // Open file that will block until interrupt is received
  gpio_fd = open((gpio_path + "value").c_str(), 'r');
  if (gpio_fd < 0)
    std::cout << "Failed in opening Vectornav sync GPIO" << std::endl;
  // TODO Set sample rate to 200Hz (default is 400Hz)
  std::cout << "Vectornav IMU Initialization done" << std::endl;
}

void VNAVDriver::WriteRegister(uint8_t reg_addr, uint8_t* payload, size_t len)
{
  tx_buf[0] = CMD_WRITE;
  tx_buf[1] = reg_addr;
  tx_buf[2] = 0;
  tx_buf[3] = 0;
  for (size_t i=0; i<len; ++i)
    tx_buf[4 + i] = payload[i];
  Transmit(4 + len, 0);
}

void VNAVDriver::SetupRead(int reg_addr)
{
  tx_buf[0] = CMD_READ;
  tx_buf[1] = reg_addr;
  tx_buf[2] = 0;
  tx_buf[3] = 0;
  write(spi_fd, &tx_buf[0], HEADER_LEN);
}

void VNAVDriver::waitNewSample()
{
  // Poll falling edge interrupt on GPIO
  struct pollfd pfd;
  int tmp;
  pfd.fd = gpio_fd;
  pfd.events = POLLPRI;
  poll(&pfd, 1, -1);
  // Reset interrupt
  lseek(gpio_fd, 0, SEEK_SET); 
  read(gpio_fd, &tmp, sizeof(tmp));
}

bool VNAVDriver::readSensors(IMUReading &ret)
{
  SetupRead(STATE_REGADDR);
  usleep(50); // Bit of a magic number, datasheet says minimum 100uS but there is system delays
  read(spi_fd, &rx_buf[0], STATE_LEN + HEADER_LEN);
  // Error received
  if (rx_buf[3] != 0)
    return 1;
  float* data_ptr = (float*)rx_buf;
  ret.q_x = data_ptr[1];
  ret.q_y = data_ptr[2];
  ret.q_z = data_ptr[3];
  ret.q_w = data_ptr[4];
  ret.a_x = data_ptr[8];
  ret.a_y = data_ptr[9];
  ret.a_z = data_ptr[10];
  ret.g_x = data_ptr[11];
  ret.g_y = data_ptr[12];
  ret.g_z = data_ptr[13];
  return 0;
}
