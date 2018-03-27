#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include "lightweightserial.h"

static LightweightSerial *g_port = NULL;  // raptors attack

void perish_if(bool b, const char *msg)
{
  if (b)
  {
    printf("%s\n", msg);
    exit(1);
  }
}

void usage()
{
  printf("usage:  mcu_cli COMMAND [ARGUMENTS]\n");
  printf("  available commands:\n");
  printf("    ping\n");
  printf("    dump_fpga_image\n");
  printf("    flash_fpga_image FILENAME\n");
  printf("    verify_fpga_image FILENAME\n");
  printf("    bootloader_dump_flash\n");
  printf("    configure_fpga\n");
  printf("    get_fpga_image_crc32\n");
  printf("\n");
  exit(1);
}

const uint8_t MCU_BL_ACK  = 0x79;
const uint8_t MCU_BL_NACK = 0x1f;
const uint8_t MCU_BL_CMD_ENTER_BOOTLOADER = 0x7f;

bool enter_bootloader()
{
  // try to send it the "go to bootloader" command
  g_port->write(MCU_BL_CMD_ENTER_BOOTLOADER);

  bool got_response = false;
  for (int attempt = 0; attempt < 10; attempt++) {
    uint8_t b = 0;
    if (g_port->read(&b)) {
      got_response = true;
      if (b == MCU_BL_ACK) {
        printf("hooray, MCU entered bootloader mode\n");
        return true;
      }
      else {
        printf("MCU is already in bootloader mode\n");
        return true;
      }
    }
    else
      usleep(10000);
  }

  // send another byte, in case we are already in bootloader mode
  g_port->write(MCU_BL_CMD_ENTER_BOOTLOADER);
  for (int attempt = 0; attempt < 10; attempt++) {
    uint8_t b = 0;
    if (g_port->read(&b)) {
      got_response = true;
      if (b == MCU_BL_ACK)
        printf("hooray, MCU entered bootloader mode\n");
      else
        printf("MCU is already in bootloader mode\n");
    }
    else
      usleep(10000);
  }

  if (!got_response) {
    printf("bummer, didn't get a response from the MCU bootloader :(\n");
    return false;
  }
  // todo: confirm version or chip ID or whatever?
  return true;
}

bool receive_ack()
{
  bool got_response = false;
  for (int attempt = 0; attempt < 20; attempt++) {
    uint8_t b = 0;
    if (g_port->read(&b)) {
      got_response = true;
      // printf("receive_ack() read 0x%02x\n", (unsigned)b);
      if (b == MCU_BL_ACK)
        return true;
      else
        return false;
    }
    else
      usleep(10000);
  }
  return false;  // time ran out. bummer.
}

bool bootloader_read_bytes(uint32_t addr, uint32_t len, uint8_t *buf)
{
  if (len == 0 || len > 255)
    return false;
  g_port->write((uint8_t)0x11);
  g_port->write((uint8_t)0xee);
  if (!receive_ack()) {
    printf("no response to bootloader read memory header\n");
    return false;
  }
  uint8_t addr_csum = 0;
  for (int i = 0; i < 4; i++) {
    uint8_t addr_byte = (uint8_t)((addr >> ((3 - i)*8)) & 0xff);
    g_port->write(addr_byte);
    addr_csum ^= addr_byte;
  }
  g_port->write(addr_csum);
  if (!receive_ack()) {
    printf("no response to bootloader read memory address transmission\n");
    return false;
  }
  g_port->write((uint8_t)len);
  g_port->write((uint8_t)(~((uint8_t)len)));
  if (!receive_ack()) {
    printf("no response to bootloader read memory length transmission\n");
    return false;
  }
  for (int i = 0; i < len; i++) {
    // read a byte
    bool received_something = false;
    for (int attempt = 0; attempt < 10; attempt++) {
      uint8_t b = 0;
      if (g_port->read(&b)) {
        buf[i] = b;
        received_something = true;
        break;
      }
      else
        usleep(10000);
    }
    if (!received_something) {
      printf("timed out after reading %d bytes from MCU memory\n", i);
      return false;
    }
  }

  // receive the memory block checksum
  bool received_csum = false;
  uint8_t csum = 0;
  for (int attempt = 0; attempt < 10; attempt++) {
    uint8_t b = 0;
    if (g_port->read(&b)) {
      received_csum = true;
      csum = b;
      break;
    }
    else
      usleep(10000);
  }
  if (!received_csum) {
    printf("didn't receive memory block checksum\n");
    return false;
  }

  // todo: verify checksum

  return true;
}

int bootloader_dump_flash()
{
  enter_bootloader();
  const uint32_t FLASH_BASE_ADDR = 0x08000000;
  const uint32_t FLASH_LEN = 1024;
  const uint32_t FLASH_READ_LEN = 16;
  uint8_t flash_read_buf[256] = {0};
  for (uint32_t addr = FLASH_BASE_ADDR;
    addr < FLASH_BASE_ADDR + FLASH_LEN;
    addr += FLASH_READ_LEN) {
    if (!bootloader_read_bytes(addr, FLASH_READ_LEN, flash_read_buf)) {
      printf("error reading from address 0x%08x\r\n", addr);
      return 1;
    } else {
      printf("read OK from address 0x%08x\r\n", addr);
      for (int i = 0; i < FLASH_READ_LEN; i++) {
        printf(" %02x", (unsigned)flash_read_buf[i]);
        if (i % 16 == 15)
          printf("\n");
      }
    }
  }
  return 0;
}

bool send_packet(const uint8_t *p, const uint32_t len)
{
  if (len > 255) {
    printf("packet too long: %d\n", (int)len);
    return false;
  }
  uint8_t pkt[300] = {0};
  pkt[0] = 0x42;
  pkt[1] = (uint8_t)len;
  uint8_t csum = pkt[1];
  for (int i = 0; i < len; i++) {
    pkt[2+i] = p[i];
    csum += i + p[i];
  }
  pkt[2+len] = ~csum;
  g_port->write_block(pkt, 3+len);
#ifdef PRINT_TX_PACKET
  printf("sending:\n");
  for (int i = 0; i < 3+len; i++) {
    printf("  0x%02x", (unsigned)pkt[i]);
    if (i % 16 == 15)
      printf("\n");
  }
  printf("\n");
#endif
  return true;
}

typedef enum
{
  PS_START, PS_LENGTH, PS_DATA, PS_CSUM
} parser_state_t;

bool parse_rx_byte(const uint8_t b)
{
  //printf("rx: 0x%02x\n", (unsigned)b);
  static parser_state_t ps = PS_START;
  static uint8_t expected_len = 0;
  static uint8_t payload[256] = {0};
  static uint8_t payload_wpos = 0;
  static uint8_t payload_csum = 0;
  switch (ps) {
    case PS_START:
      if (b == 0x42)
        ps = PS_LENGTH;
      break;
    case PS_LENGTH:
      expected_len = b;
      payload_wpos = 0;
      payload_csum = b;
      ps = PS_DATA;
      break;
    case PS_DATA:
      payload_csum += b + payload_wpos;
      payload[payload_wpos++] = b;
      if (payload_wpos >= expected_len)
        ps = PS_CSUM;
      break;
    case PS_CSUM:
      ps = PS_START;
      if ((~b & 0xff) == payload_csum) {
        //printf("CSUM OK\n");
        return true;  // hit end-of-packet
      }
      else
      {
        printf("csum mismatch: expected 0x%02x received 0x%02x\r\n",
               (~payload_csum) & 0xff, b);
      }
      break;
    default:
      ps = PS_START;
      break;
  }
  return false;  // didn't hit end-of-packet
}

int await_response(uint8_t *p, const uint32_t maxlen)
{
  int timeouts = 0;
  int nrx = 0;
  while (timeouts < 300) {
    uint8_t b = 0;
    if (g_port->read(&b)) {
      p[nrx] = b;
      nrx++;
      if (parse_rx_byte(b))
        return nrx;
      if (nrx >= maxlen) {
        printf("WOAH! rx buffer overrun in await_response\n");
        return 0;  // overrun
      }
    }
    else {
      timeouts++;
      usleep(10000);
    }
  }
  return 0;
}

int ping()
{
  uint8_t pkt[1] = {0x1};
  send_packet(pkt, 1);
  uint8_t response[10] = {0};
  int nrx = await_response(response, sizeof(response));
  if (nrx != 4) {
    printf("wrong ping response length: %d\n", nrx);
    return 1;
  }
  if (response[2] != 2) {
    printf("unexpected ping response byte: 0x%02x\n", (unsigned)response[2]);
    return 1;
  }
  printf("ping response OK\n");
  return 0;
}

int configure_fpga()
{
  uint8_t pkt[1] = {0x4};
  send_packet(pkt, 1);
  uint8_t response[10] = {0};
  int nrx = await_response(response, sizeof(response));
  if (nrx != 4) {
    printf("wrong configure response length: %d\n", nrx);
    return 1;
  }
  if (response[2] != 1) {
    printf("unexpected configure response: 0x%02x\n", (unsigned)response[2]);
    return 1;
  }
  printf("ping response OK\n");
  return 0;
}

bool read_flash(const uint32_t start_addr, const uint8_t len,
    uint8_t *data)
{
  //printf("read_flash(0x%08x, %d)\n", (unsigned)start_addr, (int)len);
  uint8_t mem_read_request_pkt[6];
  mem_read_request_pkt[0] = 0x2;  // read memory command
  mem_read_request_pkt[1] = len;  // read length
  memcpy(&mem_read_request_pkt[2], &start_addr, 4);
  send_packet(mem_read_request_pkt, sizeof(mem_read_request_pkt));
  uint8_t response[260] = {0};
  int nrx = await_response(response, sizeof(response));
  //printf("received %d bytes\n", nrx);
  if (nrx != len + 3) {
    printf("unexpected response length: %d\n", nrx);
    return false;
  }
  memcpy(data, &response[2], len);
  return true;
}

uint32_t get_crc32()
{
  uint8_t crc32_request_pkt[1] = {5};  // crc32 request command
  send_packet(crc32_request_pkt, 1);
  uint8_t response[10] = {0};
  int nrx = await_response(response, sizeof(response));
  if (nrx != sizeof(uint32_t) + 3) {
    printf("wrong crc32 response length: %d\n", nrx);
    return 0xffffffff;
  }
  for (int i = 0; i < nrx; i++) {
    printf("%d: 0x%02x\n", i, (unsigned)response[i]);
  }
  uint32_t crc32 = 0;
  memcpy(&crc32, &response[2], 4);
  return crc32;
}

int dump_fpga_image()
{
  uint32_t image_len = 0;
  if (!read_flash(0x08010000, 4, (uint8_t *)&image_len)) {
    printf("couldn't read flash header :(\n");
    return 1;
  }
  printf("image length: %u = 0x%08x\n",
    (unsigned)image_len, (unsigned)image_len);
  if (image_len == 0xffffffff) {
    printf("ERROR: FPGA image not present in MCU flash.\n");
    return 1;
  }
  FILE *f = fopen("fpga_image.bin", "wb");
  if (!f) {
    printf("couldn't open fpga_image.bin for writing :(\n");
    return 1;
  }
  const uint32_t FPGA_IMAGE_START_ADDR = 0x08010008;
  const uint8_t READ_LEN = 8;
  uint8_t flash_buf[READ_LEN] = {0};
  for (int addr = FPGA_IMAGE_START_ADDR;
    addr < FPGA_IMAGE_START_ADDR + image_len;
    addr += READ_LEN) {
    //printf("reading from 0x%08x\n", (unsigned)addr);
    if (!read_flash(addr, READ_LEN, flash_buf)) {
      printf("unable to read flash at addr 0x%08x\n", (unsigned)addr);
      return 1;
    }
    if (READ_LEN != fwrite(flash_buf, 1, READ_LEN, f)) {
      printf("error writing to dump file :(\n");
      return 1;
    }
  }
  if (0 != fclose(f)) {
    printf("error closing dump file :(\n");
    return 1;
  }
  return 0;
}

bool write_flash(const uint32_t start_addr, const uint8_t len,
    const uint8_t *data)
{
  printf("write_flash(0x%08x, %d)\n", (unsigned)start_addr, (int)len);
  uint8_t write_pkt[270] = {0};
  write_pkt[0] = 0x3;  // write memory command
  write_pkt[1] = len;
  memcpy(&write_pkt[2], &start_addr, 4);
  memcpy(&write_pkt[6], data, len);
  if (!send_packet(write_pkt, len + 6)) {
    printf("error writing flash :(\n");
    return false;
  }
  uint8_t response[10] = {0};
  int nrx = await_response(response, sizeof(response));
  if (nrx <= 0 || response[2] != 0) {
    printf("bad response to write-flash command :(\n");
    return false;
  }
  return true;
}

int verify_fpga_image(int argc, char **argv)
{
  if (argc < 3)
    usage();
  const char *filename = argv[2];
  printf("flashing %s...\n", filename);
  FILE *f = fopen(filename, "rb");
  if (!f) {
    printf("couldn't open %s for reading :(\n", filename);
    return 1;
  }
  if (fseek(f, 0L, SEEK_END) < 0) {
    printf("error seeking end of file :(\n");
    return 1;
  }
  int len = (int)ftell(f);
  rewind(f);
  printf("file size: %d\n", len);
  // verify the file size
  const uint32_t READ_LEN = 128;
  uint8_t read_buf[READ_LEN] = {0};
  if (!read_flash(0x08010000, 4, read_buf)) {
    printf("unable to read image size from MCU flash :(\n");
    return 1;
  }
  uint32_t read_flash_size = 0;
  memcpy(&read_flash_size, read_buf, 4);
  if (read_flash_size != len) {
    printf("file size mismatch found during verify stage!\n");
    printf("expected %d bytes, found %d stored in flash header\n",
        len, read_flash_size);
    return 1;
  }
  // read back all the flash bits and verify against the original file
  uint8_t file_buf[READ_LEN] = {0};
  int verify_read_count = 0;
  for (uint32_t addr = 0x08010008; addr < addr + len; addr += READ_LEN)
  {
    if (verify_read_count++ % 16 == 0)
      printf("verifying 0x%08x...\n", (unsigned)addr);
    if (!read_flash(addr, READ_LEN, read_buf)) {
      printf("couldn't read from MCU flash at addr 0x%08x\n", (unsigned)addr);
      return 1;
    }
    int nread = fread(file_buf, 1, READ_LEN, f);
    if (nread < 0) {
      printf("error reading from file during verify step :(\n");
      return 1;
    }
    if (nread == 0) {
      printf("hit end of file.\n");
      break;
    }
    for (int byte = 0; byte < READ_LEN && byte < nread; byte++) {
      if (read_buf[byte] != file_buf[byte]) {
        printf(
          "mismatch at byte %d, addr 0x%08x: 0x%02x != 0x%02x, nread = %d\n",
          byte, addr + byte, read_buf[byte], file_buf[byte], nread);
        return 1;
      }
    }
  }
  printf("verification completed successfully\n");
  fclose(f);
  return 0;
}

int flash_fpga_image(int argc, char **argv)
{
  if (argc < 3)
    usage();
  const char *filename = argv[2];
  printf("flashing %s...\n", filename);
  FILE *f = fopen(filename, "rb");
  if (!f) {
    printf("couldn't open %s for reading :(\n", filename);
    return 1;
  }
  if (fseek(f, 0L, SEEK_END) < 0) {
    printf("error seeking end of file :(\n");
    return 1;
  }
  int len = (int)ftell(f);
  rewind(f);
  printf("file size: %d\n", len);
  // first write the file size
  const uint32_t WRITE_LEN = 64;
  uint8_t write_buf[WRITE_LEN] = {0};
  memcpy(write_buf, &len, 4);
  if (!write_flash(0x08010000, 8, write_buf)) {
    printf("error writing flash header\n");
    return 1;
  }
  uint32_t addr = 0x08010008;
  while (1) {
    memset(write_buf, 0, sizeof(write_buf));
    int nread = fread(write_buf, 1, WRITE_LEN, f);
    if (nread < 0) {
      printf("error reading file :(\n");
      return 1;
    }
    if (nread == 0) {
      printf("done reading file\n");
      break;
    }
    if (!write_flash(addr, WRITE_LEN, write_buf)) {
      printf("error writing flash at addr 0x%08x\n", (unsigned)addr);
      return 1;
    }
    if (feof(f)) {
      printf("hit end of file.\n");
      break;
    }
    addr += WRITE_LEN;
  }
  printf("done writing to flash\n");
  fclose(f);
  return verify_fpga_image(argc, argv);
}

#define CHECK_SERIAL_DEVICE

int main(int argc, char **argv)
{
  if (argc < 2)
    usage();
  g_port = new LightweightSerial("/dev/ttyTHS1", 115200);
#ifdef CHECK_SERIAL_DEVICE
  perish_if(!g_port, "could't open serial device");
  perish_if(!g_port->is_ok(), "serial device is not happy");
#endif
  const char *cmd = argv[1];
  if (!strcmp(cmd, "bootloader_dump_flash"))
    return bootloader_dump_flash();
  else if (!strcmp(cmd, "ping"))
    return ping();
  else if (!strcmp(cmd, "dump_fpga_image"))
    return dump_fpga_image();
  else if (!strcmp(cmd, "flash_fpga_image"))
    return flash_fpga_image(argc, argv);
  else if (!strcmp(cmd, "verify_fpga_image"))
    return verify_fpga_image(argc, argv);
  else if (!strcmp(cmd, "configure_fpga"))
    return configure_fpga();
  else if (!strcmp(cmd, "get_fpga_image_crc32")) {
    printf("%08x\n", get_crc32());
    return 0;
  }
  else {
    printf("unknown command: %s\n", cmd);
    usage();
  }
  return 0;
}
