///////////////////////////////////////////////////////////////////////////////
// The serial_port package provides small, simple static libraries to access 
// serial devices
//
// Copyright (C) 2008, Morgan Quigley
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//   * Redistributions of source code must retain the above copyright notice, 
//     this list of conditions and the following disclaimer.
//   * Redistributions in binary form must reproduce the above copyright 
//     notice, this list of conditions and the following disclaimer in the 
//     documentation and/or other materials provided with the distribution.
//   * Neither the name of Stanford University nor the names of its 
//     contributors may be used to endorse or promote products derived from 
//     this software without specific prior written permission.
//   
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.

#ifndef SERIALPORT_LIGHTWEIGHT_SERIAL_H
#define SERIALPORT_LIGHTWEIGHT_SERIAL_H

#include <stdint.h>

class LightweightSerial
{
  public:
    LightweightSerial(const char *port, int baud);
    ~LightweightSerial();

    bool read(uint8_t *b);
    int read_block(uint8_t *block, uint32_t max_read_len);

    bool write(const uint8_t b);
    bool write_block(const uint8_t *block, uint32_t write_len);
    bool write_cstr(const char *cstr);

    inline bool is_ok() { return happy; }

    // type-conversion wrappers so we can handle either signed or unsigned
    inline bool read(char *c) { return read((uint8_t *)c); }
    inline int read_block(char *block, uint32_t max_read_len) { return read_block(block, max_read_len); }
    inline bool write(char c) { return write((uint8_t)c); }
    inline bool write_block(const char *block, uint32_t write_len) { return write_block((uint8_t *)block, write_len); }

  private:
    int baud;
    int fd;
    bool happy;
};

#endif

