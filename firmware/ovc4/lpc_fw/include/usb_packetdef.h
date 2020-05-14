#ifndef USB_PACKETDEF_INC
#define USB_PACKETDEF_INC

#define NUM_JOINTS 5

#define REGOP_NUM 8
#define NUM_TRAJ_POINTS 15

#define NUM_EAC 260 // Seems to be 257 on tested boards

#define USB_VID 0x1fc9
#define USB_PID 0x0094

// Mask for register_updated bitfield
#define SENSORS_UPDATED_MASK 1
#define ENCODER_UPDATED_MASK (1 << 1)
#define SETPOINT_UPDATED_MASK (1 << 2)

// Packet definitions for controller board -> host PC

typedef enum
#ifdef __cplusplus
: uint16_t
#endif
{
  TX_PACKET_TYPE_IMU = 0,
  TX_PACKET_TYPE_FORCE_16BIT = 0xFFFF 
} tx_packet_type_t;

typedef enum
#ifdef __cplusplus
: uint16_t
#endif
{
  RX_PACKET_TYPE_CMD_RESET = 0,
  RX_PACKET_TYPE_FORCE_16BIT = 0xFFFF
} rx_packet_type_t; 

typedef struct __attribute__((__packed__)) {
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
  float acc_x;
  float acc_y;
  float acc_z;
  float gyro_x;
  float gyro_y;
  float gyro_z;
} usb_tx_imu_t;

typedef struct __attribute__((__packed__))
{
  uint32_t status;
  tx_packet_type_t packet_type;
  uint8_t device_id;
  uint8_t reserved;
} usb_tx_header_t;

typedef union
{
  usb_tx_imu_t imu;
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
  uint32_t timestamp;
  uint16_t status;
  rx_packet_type_t packet_type;
} usb_rx_header_t;

typedef union __attribute__((__packed__))
{
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
