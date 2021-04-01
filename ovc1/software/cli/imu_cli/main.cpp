#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <unistd.h>
#include <signal.h>
#include "lightweightserial.h"

static LightweightSerial *g_port = NULL;  // raptors attack
bool g_done = false;

void sigint_handler(int signum)
{
  g_done = true;
}

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
  printf("usage:  imu_cli COMMAND [ARGUMENTS]\n");
  printf("  available commands:\n");
  printf("    configure\n");
  printf("    listen\n");
  printf("    read REGISTER_INDEX\n");
  printf("\n");
  exit(1);
}

int listen()
{
  uint8_t buf[256] = {0};
  while (!g_done) {
    int nread = g_port->read_block(buf, sizeof(buf));
    // these reads should be buffered lines bubbling up the tegra uart driver
    if (nread) {
      //printf("read %d\n", nread);
      if (nread > 6) {
        /*
        if (buf[0] == '$') {
          printf("%.5s\n", buf+1);
        }
        */
        /*
        if (!strncmp((char *)(buf+1), "VNYMR", 5)) {
          printf("%s\n", buf);
        }
        */
        if (buf[0] == '$') {
          // our read is aligned with the message start
          if (0 != strncmp((char *)(buf+1), "VNYMR", 5))
            printf("%s\n", buf);
        }
      }
      for (int i = 0; i < nread; i++) {
        /*
        uint8_t b = buf[i];
        if (b < 0x20)
          printf("rx 0x%02x\n", b);
        */
      }
    }
    else
      usleep(1000);
  }
  printf("goodbye\n");
  return 0;
}

void append_checksum(char *msg)
{
  if (!msg) {
    printf("WOAH THERE PARTNER. you send append_checksum() a null string.\n");
    exit(1);
  }
  if (msg[0] != '$') {
    printf("WOAH THERE PARTNER. expected message string to begin with '$'\n");
    exit(1);
  }
  int msg_len = strlen(msg);
  uint8_t csum = 0;
  for (int i = 1; i < msg_len; i++)
    csum ^= msg[i];
  char csum_ascii[10] = {0};
  snprintf(csum_ascii, sizeof(csum_ascii), "*%02x\r\n", (int)csum);
  strcat(msg, csum_ascii);
}

int read_reg(int argc, char **argv)
{
  if (argc < 3)
    usage();
  int reg_idx = atoi(argv[2]);
  printf("reading register %d\n", reg_idx);

  // read a few messages to clean the buffer
  uint8_t buf[256] = {0};
  for (int attempt = 0; attempt < 100 && !g_done; attempt++) {
    int nread = g_port->read_block(buf, sizeof(buf));
    // these reads should be buffered lines bubbling up the tegra uart driver
    if (nread) {
      //printf("read %d\n", nread);
    }
    else
      usleep(1000);
  }
 
  char request[64] = {0};
  snprintf(request, sizeof(request), "$VNRRG,%d", reg_idx);
  append_checksum(request);
  //printf("request: [%s]\n", request);
  g_port->write_cstr(request);

  for (int attempt = 0; attempt < 100 && !g_done; attempt++) {
    int nread = g_port->read_block(buf, sizeof(buf));
    // these reads should be buffered lines bubbling up the tegra uart driver
    if (nread) {
      //printf("read %d\n", nread);
      if (nread > 6) {
        /*
        if (buf[0] == '$') {
          printf("%.5s\n", buf+1);
        }
        */
        /*
        if (!strncmp((char *)(buf+1), "VNYMR", 5)) {
          printf("%s\n", buf);
        }
        */
        if (buf[0] == '$') {
          // our read is aligned with the message start
          if (0 != strncmp((char *)(buf+1), "VNYMR", 5))
            printf("%s\n", buf);
        }
      }
      for (int i = 0; i < nread; i++) {
        /*
        uint8_t b = buf[i];
        if (b < 0x20)
          printf("rx 0x%02x\n", b);
        */
      }
    }
    else
      usleep(1000);
  }
  usleep(100000);
 
  //g_port->write((uint8_t)0x11);
  //g_port->write((uint8_t)0xee);
  return 0;
}

int configure()
{
  // disable async data output
  char request[64] = {0};
  snprintf(request, sizeof(request), "$VNWRG,06,0");
  append_checksum(request);
 
  printf("request: [%s]\n", request);
  g_port->write_cstr(request);
 
  return 0;
}
 
#define CHECK_SERIAL_DEVICE

int main(int argc, char **argv)
{
  if (argc < 2)
    usage();
  g_port = new LightweightSerial("/dev/ttyTHS6", 115200);
#ifdef CHECK_SERIAL_DEVICE
  perish_if(!g_port, "could't open serial device");
  perish_if(!g_port->is_ok(), "serial device is not happy");
#endif
  signal(SIGINT, sigint_handler);
  const char *cmd = argv[1];
  if (!strcmp(cmd, "listen"))
    return listen();
  else if (!strcmp(cmd, "read"))
    return read_reg(argc, argv);
  else if (!strcmp(cmd, "configure"))
    return configure();
  else {
    printf("unknown command: [%s]\n", cmd);
    return 1;
  }
  return 0;
}
