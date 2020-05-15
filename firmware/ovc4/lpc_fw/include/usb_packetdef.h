#ifndef USB_PACKETDEF_INC
#define USB_PACKETDEF_INC

#define USB_VID 0x1fc9
#define USB_PID 0x0094

// First 10 regops are for cam 0, etc.
#define NUM_REGOPS 60
#define NUM_CAMERAS 6
#define REGOPS_PER_CAM (NUM_REGOPS / NUM_CAMERAS)

// Packet definitions for controller board -> host PC

typedef enum
#ifdef __cplusplus
: uint16_t
#endif
{
  TX_PACKET_TYPE_IMU = 1, // Packet with IMU data
  TX_PACKET_TYPE_I2C_RESULT = 2, // Result of regops received through an I2C_PROBE packet
  TX_PACKET_TYPE_FORCE_16BIT = 0xFFFF 
} tx_packet_type_t;

typedef enum
#ifdef __cplusplus
: uint16_t
#endif
{
  RX_PACKET_TYPE_CMD_RESET = 1,
  RX_PACKET_TYPE_I2C_PROBE = 2, // Probing sensors is not time sensitive and should be robust to failed transactions
  RX_PACKET_TYPE_I2C_SYNC = 3,  // Synchronous transactios (for exposure), should not fail and happen synchronously
  RX_PACKET_TYPE_FORCE_16BIT = 0xFFFF
} rx_packet_type_t; 

// TODO support multiple register sizes in regop type
typedef enum
#ifdef __cplusplus
: uint16_t
#endif
{
  REGOP_OK = 1,
  REGOP_NAK = 2,
  REGOP_READ = 3,
  REGOP_WRITE = 4,
  REGOP_INVALID = 0xFFFF
} regop_status_t;

typedef struct __attribute__((__packed__)) {
  regop_status_t status;
  int16_t addr;
  union {
    float f32;
    int32_t i32;
    uint32_t u32;
    uint16_t u16;
    uint8_t u8;
  };
} reg_op_t;

typedef struct __attribute__((__packed__))
{
  reg_op_t regops[NUM_REGOPS];
} usb_txrx_i2c_t;

typedef struct __attribute__((__packed__))
{
  float acc_x;
  float acc_y;
  float acc_z;
  float gyro_x;
  float gyro_y;
  float gyro_z;
} usb_tx_imu_t;

typedef struct __attribute__((__packed__))
{
  uint16_t status;
  tx_packet_type_t packet_type;
} usb_tx_header_t;

typedef union
{
  usb_tx_imu_t imu;
  usb_txrx_i2c_t i2c;
} usb_tx_payload_t;

typedef union usb_tx_packet_t
{
  struct
  {
    usb_tx_header_t header;
    usb_tx_payload_t pkt;
  };
  uint8_t data[1]; // We don't need to code magic numbers for size, ref  https://electronics.stackexchange.com/questions/296348/union-member-and-size-of-char-array-in-c
} usb_tx_packet_t;

// Packet definitions for host PC -> controller board

typedef struct __attribute__((__packed__))
{
  uint16_t status;
  rx_packet_type_t packet_type;
} usb_rx_header_t;

typedef union __attribute__((__packed__))
{
  usb_txrx_i2c_t i2c;
} usb_rx_payload_t;

typedef union __attribute__((__packed__))
{
  struct __attribute__((__packed__))
  {
    usb_rx_header_t header;
    usb_rx_payload_t pkt;
  };
  uint8_t data[1];
} usb_rx_packet_t;

#endif
