#include <fcntl.h>
#include <string>
#include <iostream>
#include <vector>
#include <sys/ioctl.h>
extern "C"
{
  #include <linux/i2c.h>
  #include <linux/i2c-dev.h>
  #include <i2c/smbus.h>
}
#include <ovc_embedded_driver/i2c_driver.h>

I2CDriver::I2CDriver(int i2c_num) :
  exp_high_thresh(DEFAULT_EXP_HIGH_THRESH), exp_low_thresh(DEFAULT_EXP_LOW_THRESH),
  cur_analog_gain(MIN_ANALOG_GAIN)
{
  std::string i2c_filename("/dev/i2c-" + std::to_string(i2c_num));
  i2c_fd = open(i2c_filename.c_str(), O_RDWR);
  if (i2c_fd == -1)
    std::cout << "Couldn't open I2C file " << i2c_filename << std::endl;

  // Set the slave address for the device
  if (ioctl(i2c_fd, I2C_SLAVE, CAMERA_ADDRESS) < 0)
    std::cout << "Couldn't set slave address" << std::endl;
  configurePLL(EXTCLK_FREQ, VCO_FREQ, PIXEL_RES);
  configureGPIO();
  configureMIPI();
  //enableTestMode();
  std::cout << "I2C Initialization done" << std::endl;
}

int16_t I2CDriver::readRegister(uint16_t reg_addr)
{
  i2c_smbus_write_byte_data(i2c_fd, reg_addr >> 8, reg_addr & 0xFF);
  int16_t ret_val = 0;
  // Data is returned MSB first
  for (int i=sizeof(reg_addr)-1; i>=0; --i)
    ret_val |= i2c_smbus_read_byte(i2c_fd) << (i*8); 
  return ret_val;
}

void I2CDriver::writeRegister(uint16_t reg_addr, int val)
{
  std::vector<uint8_t> payload(sizeof(reg_addr) + 1); // We need to add one byte for address
  payload[0] = reg_addr & 0xFF;
  for (size_t i=1; i<=sizeof(reg_addr); ++i)
    payload[i] = val >> (8 * (sizeof(reg_addr) - i));
  i2c_smbus_write_i2c_block_data(i2c_fd, reg_addr >> 8, payload.size(), &payload[0]); 
}

void I2CDriver::configurePLL(int input_freq, int target_freq, int pixel_res)
{
  //int pll_mult = 2 * target_freq / input_freq; 
  //std::cout << "PLL mult = " << pll_mult << std::endl;
  // Assuming the multiplier can be high enough and will not overflow (max 255?)
  // TODO documentation ambiguous on the clocks, check...
  writeRegister(PLL_MULTIPLIER, 144);
  // We will not divide the input clock
  writeRegister(PRE_PLL_CLK_DIV, 5);
  // Pixel resolution defines number of clocks per pixel
  writeRegister(VT_PIX_CLK_DIV, 4); // DDR?
  // 1 in documentation
  writeRegister(VT_SYS_CLK_DIV, 2);
  // OP registers have same values
  writeRegister(OP_PIX_CLK_DIV, 8);
  writeRegister(OP_SYS_CLK_DIV, 1);
}

void I2CDriver::configureGPIO()
{
  // Enable input buffers
  int16_t reg_val = readRegister(RESET_REGISTER);
  reg_val |= 1 << 8;
  //reg_val |= 1 << 11; // Force PLL ON (likely unnecessary)
  writeRegister(RESET_REGISTER, reg_val);
  // Enable flash output for debugging purposes
  writeRegister(LED_FLASH_CONTROL, 1 << 8);
}
void I2CDriver::configureMIPI()
{
  // Start with image config
  writeRegister(Y_ADDR_START, 0);
  writeRegister(X_ADDR_START, 4);
  writeRegister(Y_ADDR_END, 799);
  writeRegister(X_ADDR_END, 1283);
  writeRegister(X_ODD_INC, 1);
  writeRegister(Y_ODD_INC, 1);
  writeRegister(OPERATION_MODE_CTRL, 3);
  writeRegister(READ_MODE, 0);
  writeRegister(FRAME_LENGTH_LINES, 874);
  writeRegister(LINE_LENGTH_PCK, 1488);
  writeRegister(COARSE_INTEGRATION_TIME, 873);
  // Enable embedded data
  writeRegister(SMIA_TEST, 0x1982); // Enables all
  writeRegister(AECTRLREG, 3); // Enable control of exposure and gain (NOTE gain not working)
  writeRegister(AE_LUMA_TARGET_REG, 0x5000);
  writeRegister(AE_MAX_EXPOSURE_REG, 873/2); // Originally 0x02A0 
  writeRegister(AE_DAMP_MAX_REG, 0x0110);
  writeRegister(AE_EG_EXPOSURE_HI, 873/2 - 100); 
  writeRegister(AE_EG_EXPOSURE_LO, 100); 
  // Change to single lane
  writeRegister(SERIAL_FORMAT, 0x0201);
  writeRegister(COMPANDING, 0);
  // 10 bit output, check precompression?
  writeRegister(DATA_FORMAT_BITS, 0x0808);
  writeRegister(DATAPATH_SELECT, 0x9010);
  // Magic numbers given by the ON semi register wizard software
  writeRegister(FRAME_PREAMBLE, 99);
  writeRegister(LINE_PREAMBLE, 67);
  writeRegister(MIPI_TIMING_0, 7047);
  writeRegister(MIPI_TIMING_1, 8727);
  writeRegister(MIPI_TIMING_2, 16459);
  writeRegister(MIPI_TIMING_3, 521);
  writeRegister(MIPI_TIMING_4, 8);
}

void I2CDriver::enableTestMode()
{
  // Set test pattern mode, 1 = solid color 2 = bars 3 = fade to gray 256 = walking 1
  writeRegister(TEST_DATA_RED, 0x1111);
  writeRegister(TEST_DATA_GREENR, 0x2222);
  writeRegister(TEST_DATA_BLUE, 0x3333);
  writeRegister(TEST_DATA_GREENB, 0x4444);
  writeRegister(TEST_PATTERN_MODE, 1);
  std::cout << "Reset reg = " << std::hex << readRegister(RESET_REGISTER) << std::endl;

  std::cout << "GPI reg = " << std::hex << readRegister(GPI_STATUS) << std::endl;
  std::cout << "FRAME reg = " << std::hex << readRegister(FRAME_STATUS) << std::endl;
  std::cout << "SERIAL_TEST reg = " << std::hex << readRegister(SERIAL_TEST) << std::endl;
}

uint16_t I2CDriver::getIntegrationTime() 
{
  return readRegister(AE_COARSE_INTEGRATION_TIME);
}

void I2CDriver::changeTestColor()
{
  static int color=0;
  int red = color == 0 ? 0xFFFF : 0; 
  int green = color == 0 ? 0xFFFF : 0; 
  int blue = color == 0 ? 0xFFFF : 0; 
  writeRegister(TEST_DATA_RED, red);
  writeRegister(TEST_DATA_GREENR, green);
  writeRegister(TEST_DATA_BLUE, blue);
  writeRegister(TEST_DATA_GREENB, green);
  color = (color + 1) % 2;
}

uint16_t I2CDriver::getCurrentGains()
{
  return readRegister(CURRENT_GAINS) >> 11; 
}

void I2CDriver::setAnalogGain(uint16_t gain)
{
  uint16_t reg_val = readRegister(AECTRLREG); 
  // Analog gain is bits 5 and 6
  uint16_t select_mask = 0b11 << 5; 
  reg_val &= ~select_mask;
  reg_val |= (gain << 5) & select_mask;
  writeRegister(AECTRLREG, reg_val);
}

void I2CDriver::controlAnalogGain()
{
  // Analog gain is 2^cur_analog_gain
  uint16_t int_time = getIntegrationTime();
  if (int_time > exp_high_thresh && cur_analog_gain < MAX_ANALOG_GAIN)
    setAnalogGain(++cur_analog_gain);
  else if (int_time < exp_low_thresh && cur_analog_gain > MIN_ANALOG_GAIN)
    setAnalogGain(--cur_analog_gain);
}
