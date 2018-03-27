#include "ovc.h"

int main(int argc, char **argv)
{
  uint8_t test_img[16] = {0, 0, 0, 0,
                          1, 0, 0, 0,
                          2, 0, 0, 0,
                          3, 0, 0, 0};
  /*
  uint8_t test_img[1024] = {0};
  int cnt = 0;
  for (int i = 0; i < sizeof(test_img); i+=4) {
    test_img[i] = (uint8_t)cnt;
    test_img[i+1] = (uint8_t)(cnt >> 8);
    test_img[i+2] = (uint8_t)(cnt >> 16);
    test_img[i+3] = (uint8_t)(cnt >> 24);
    cnt++;
  }
  */

  OVC ovc;
  uint32_t sig = 0;
  ovc.validate_signature(test_img, 16, &sig);
  return 0;
}
