#ifndef SPI_DRIVER_H
#define SPI_DRIVER_H
#include <string>

#include <ovc_embedded_driver/uio_driver.h>

struct IMUReading
{
  float q_x, q_y, q_z, q_w;
  float m_x, m_y, m_z;
  float a_x, a_y, a_z;
  float g_x, g_y, g_z; 
};

class SPIDriver 
{
  static constexpr size_t BUF_SIZE = 64;
protected:
  int spi_fd;
  unsigned char tx_buf[BUF_SIZE], rx_buf[BUF_SIZE];

  void Transmit(size_t tx_len, size_t rx_len);

public:
  SPIDriver(int spi_num, int max_speed_hz);
};

class ICMDriver : public SPIDriver
{
  static constexpr size_t GPIO_UIO_SIZE = 0x1000;
  static constexpr unsigned char MASK_WRITE = 0x00;
  static constexpr unsigned char MASK_READ = 0x80;

  static constexpr unsigned char WHO_AM_I = 0x00;
  static constexpr unsigned char USER_CTRL = 0x03;
  static constexpr unsigned char PWR_MGMT_1 = 0x06;
  static constexpr unsigned char INT_PIN_CFG = 0x0F;
  static constexpr unsigned char INT_ENABLE_1 = 0x11;
  static constexpr unsigned char INT_STATUS_1 = 0x1A;
  static constexpr unsigned char ACCEL_XOUT_H = 0x2D;

  static constexpr unsigned char REG_BANK_SEL = 0x7F;

  // Bank 2
  static constexpr unsigned char GYRO_SMPLRT_DIV = 0x00;
  static constexpr unsigned char GYRO_CONFIG_1 = 0x01;
  // Only LSB for the accel divider
  static constexpr unsigned char ACCEL_SMPLRT_DIV_2 = 0x11;
  static constexpr unsigned char ACCEL_CONFIG = 0x14;

  static constexpr unsigned char CHIP_ID = 0xEA;

  static constexpr int MAX_SPI_SPEED = 7000000;
  static constexpr float DEFAULT_ACCEL_SENS = 1./16384; // LSB / g, inverse (multiply by)
  static constexpr float DEFAULT_GYRO_SENS = 1./131; // LSB / dps

  // AXI GPIO addresses
  static constexpr unsigned int GPIO_DATA = 0x0000 / sizeof(unsigned int);
  static constexpr unsigned int GPIO2_DATA = 0x0008 / sizeof(unsigned int);
  static constexpr unsigned int GIER = 0x011C / sizeof(unsigned int);
  static constexpr unsigned int IER = 0x0128 / sizeof(unsigned int);
  static constexpr unsigned int ISR = 0x0120 / sizeof(unsigned int);

  float accel_sens, gyro_sens;

  UIODriver uio;

  void selectBank(int bank);
  void writeRegister(unsigned char addr, unsigned char val);

  unsigned char readRegister(unsigned char addr);
  void burstReadRegister(unsigned char addr, int count);

public:
  ICMDriver(int spi_num, int gpio_uio_num);
  int getSampleNumber();
  IMUReading readSensors();
  void setFrameDownsample(uint8_t downsample);
};

class VNAVDriver : public SPIDriver
{
  static constexpr uint8_t CMD_READ = 1;
  static constexpr uint8_t CMD_WRITE = 2;

  static constexpr uint8_t STATE_REGADDR = 15;
  static constexpr uint8_t STATE_LEN = 52;
  static constexpr uint8_t HEADER_LEN = 4;

  static constexpr int MAX_SPI_SPEED = 16000000;

  void WriteRegister(uint8_t reg_addr, uint8_t* payload, size_t len);
  void SetupRead(int reg_addr);

  int gpio_fd; 

public:
  VNAVDriver(int spi_num, int gpio_num);
  void waitNewSample();
  bool readSensors(IMUReading& ret);
};

#endif
