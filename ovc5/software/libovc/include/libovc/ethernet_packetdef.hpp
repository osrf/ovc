#ifndef __ETHERNET_PACKETDEF_HPP
#define __ETHERNET_PACKETDEF_HPP

#include <cstdint>

// Packet definitions for OVC -> host PC
typedef enum : uint32_t
{
  TX_PACKET_TYPE_FRAME = 1,
  TX_PACKET_TYPE_IMU = 2,  // Packet with IMU data
} ether_tx_packet_type_t;

typedef struct __attribute__((__packed__))
{
  float temperature;
  float acc_x;
  float acc_y;
  float acc_z;
  float gyro_x;
  float gyro_y;
  float gyro_z;
} ether_tx_imu_t;

// Max MTU is 15000 for USB gadget
typedef struct __attribute__((__packed__))
{
  uint64_t t_sec;
  uint64_t t_nsec;
  uint8_t camera_id;
  uint64_t frame_id;
  uint8_t bit_depth;
  uint16_t height;
  uint16_t width;
  uint16_t step;
  uint32_t frame_size;  // in bytes
  char sensor_name[8];
  char data_type[8];
} ether_tx_frame_t;

typedef union ether_tx_packet_t
{
  struct
  {
    uint32_t status;
    ether_tx_packet_type_t packet_type;
    union
    {
      ether_tx_imu_t imu;
      ether_tx_frame_t frame;
    };
  };
  // We don't need to code magic numbers for size, ref
  // https://electronics.stackexchange.com/questions/296348/union-member-and-size-of-char-array-in-c
  uint8_t data[1];
} ether_tx_packet_t;

// Packet definitions for host PC -> controller board
typedef enum : uint32_t
{
  RX_PACKET_TYPE_CMD_CONFIG = 1,
} ether_rx_packet_type_t;

typedef struct __attribute__((__packed__))
{
  float exposure;
  float frame_rate;
} ether_rx_config_t;

typedef union __attribute__((__packed__))
{
  struct __attribute__((__packed__))
  {
    uint16_t status;
    ether_rx_packet_type_t packet_type;
    union
    {
      ether_rx_config_t config;
    };
  };
  uint8_t data[1];
} ether_rx_packet_t;

#endif  // ETHERNET_PACKETDEF_HPP
