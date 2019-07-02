#include <string>

class I2CDriver
{
  static constexpr int EXTCLK_FREQ = 20;
  static constexpr int VCO_FREQ = 400;
  static constexpr int PIXEL_RES = 10;
  static constexpr unsigned char CAMERA_ADDRESS = 0x10; // 0x20 from datasheet, LSB ignored

  static constexpr uint16_t Y_ADDR_START = 0x3002;
  static constexpr uint16_t X_ADDR_START = 0x3004;
  static constexpr uint16_t Y_ADDR_END = 0x3006;
  static constexpr uint16_t X_ADDR_END = 0x3008;
  static constexpr uint16_t FRAME_LENGTH_LINES = 0x300A;
  static constexpr uint16_t LINE_LENGTH_PCK = 0x300C;
  static constexpr uint16_t COARSE_INTEGRATION_TIME = 0x3012;
  static constexpr uint16_t ANALOG_GAIN = 0x3060;
  static constexpr uint16_t DATAPATH_SELECT = 0x306E;
  static constexpr uint16_t X_ODD_INC = 0x30A2;
  static constexpr uint16_t Y_ODD_INC = 0x30A6;
  static constexpr uint16_t OPERATION_MODE_CTRL = 0x3082;

  static constexpr uint16_t RESET_REGISTER = 0x301A;

  static constexpr uint16_t GPI_STATUS = 0x3026;
  // PLL config
  static constexpr uint16_t VT_PIX_CLK_DIV = 0x302A;
  static constexpr uint16_t VT_SYS_CLK_DIV = 0x302C;
  static constexpr uint16_t PRE_PLL_CLK_DIV = 0x302E;
  static constexpr uint16_t PLL_MULTIPLIER = 0x3030;
  static constexpr uint16_t OP_PIX_CLK_DIV = 0x3036;
  static constexpr uint16_t OP_SYS_CLK_DIV = 0x3038;

  static constexpr uint16_t FRAME_STATUS = 0x303C;
  static constexpr uint16_t READ_MODE = 0x3040;

  static constexpr uint16_t SMIA_TEST = 0x3064;

  static constexpr uint16_t TEST_PATTERN_MODE = 0x3070;
  static constexpr uint16_t TEST_DATA_RED = 0x3072;
  static constexpr uint16_t TEST_DATA_GREENR = 0x3074;
  static constexpr uint16_t TEST_DATA_BLUE = 0x3076;
  static constexpr uint16_t TEST_DATA_GREENB = 0x3078;

  static constexpr uint16_t AECTRLREG = 0x3100;
  static constexpr uint16_t AE_LUMA_TARGET_REG = 0x3102;
  static constexpr uint16_t AE_DAMP_MAX_REG = 0x3110;
  static constexpr uint16_t AE_MAX_EXPOSURE_REG = 0x311C;
  static constexpr uint16_t AE_COARSE_INTEGRATION_TIME = 0x3164;
  static constexpr uint16_t AE_EG_EXPOSURE_HI = 0x3166;
  static constexpr uint16_t AE_EG_EXPOSURE_LO = 0x3168;
  static constexpr uint16_t CURRENT_GAINS = 0x312A;

  static constexpr uint16_t DATA_FORMAT_BITS = 0x31AC;
  static constexpr uint16_t SERIAL_FORMAT = 0x31AE;

  static constexpr uint16_t FRAME_PREAMBLE = 0x31B0;  
  static constexpr uint16_t LINE_PREAMBLE = 0x31B2;
  static constexpr uint16_t MIPI_TIMING_0 = 0x31B4;
  static constexpr uint16_t MIPI_TIMING_1 = 0x31B6;
  static constexpr uint16_t MIPI_TIMING_2 = 0x31B8;
  static constexpr uint16_t MIPI_TIMING_3 = 0x31BA;
  static constexpr uint16_t MIPI_TIMING_4 = 0x31BC;
  static constexpr uint16_t COMPANDING = 0x31D0;
  static constexpr uint16_t SERIAL_TEST = 0x31D8;

  static constexpr uint16_t LED_FLASH_CONTROL = 0x3270;

  static constexpr uint16_t DEFAULT_EXP_HIGH_THRESH = 426;
  static constexpr uint16_t DEFAULT_EXP_LOW_THRESH = 150;
  static constexpr uint16_t MAX_ANALOG_GAIN = 3;
  static constexpr uint16_t MIN_ANALOG_GAIN = 0;

  int i2c_fd;

  uint16_t exp_high_thresh, exp_low_thresh;
  uint16_t cur_analog_gain;

  int16_t readRegister(uint16_t reg_addr);
  void writeRegister(uint16_t reg_addr, int val);

  void configurePLL(int input_freq, int target_freq, int pixel_res);
  void configureGPIO();
  void configureMIPI();

  void setAnalogGain(uint16_t gain);

public:
  I2CDriver(int i2c_num);

  uint16_t getIntegrationTime();
  uint16_t getCurrentGains();
  void enableTestMode();
  void changeTestColor();

  void controlAnalogGain();

};
