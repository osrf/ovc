#include <string>

#include <ovc_embedded_driver/uio_driver.h>

struct IMUReading
{
  float a_x, a_y, a_z;
  float g_x, g_y, g_z; 

  int num_sample; // Number relative to start of frame, 0 means synchronised with frame start
};

class SPIDriver 
{
  static constexpr size_t BUF_SIZE = 32;
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

  static constexpr float DEFAULT_ACCEL_SENS = 16384; // LSB / g, TODO m/s?
  static constexpr float DEFAULT_GYRO_SENS = 131; // LSB / dps, TODO rad/s?

  // AXI GPIO addresses
  static constexpr unsigned int GPIO_DATA = 0x0000 / sizeof(unsigned int);
  static constexpr unsigned int GIER = 0x011C / sizeof(unsigned int);
  static constexpr unsigned int IER = 0x0128 / sizeof(unsigned int);
  static constexpr unsigned int ISR = 0x0120 / sizeof(unsigned int);

  int spi_fd;
  UIODriver uio;

  float accel_sens, gyro_sens;

  unsigned char tx_buf[BUF_SIZE], rx_buf[BUF_SIZE];

  void Transmit(size_t tx_len, size_t rx_len);

  void selectBank(int bank);
  void writeRegister(unsigned char addr, unsigned char val);

  unsigned char readRegister(unsigned char addr);
  void burstReadRegister(unsigned char addr, int count);


public:
  SPIDriver(int gpio_uio_num);
  IMUReading readSensors();

};
