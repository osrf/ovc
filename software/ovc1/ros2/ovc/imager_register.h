#ifndef IMAGER_REGISTER_H_
#define IMAGER_REGISTER_H_

#include <stdint.h>

class ImagerRegister
{
public:
  uint16_t index;
  uint16_t value;
  ImagerRegister(const uint16_t _index, const uint16_t _value)
  : index(_index), value(_value)
  {
  }
};

#endif
