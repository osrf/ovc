#include <fcntl.h>
#include <unistd.h>

#include <latency_tester.hpp>

LatencyTester::LatencyTester(const std::string& file)
{
  serial_port = open(file.c_str(), O_RDWR | O_SYNC);
  // For now ignore configurations
}

void LatencyTester::frameReceived()
{
  // Write 'A'
  const char* msg = "a";
  write(serial_port, msg, sizeof(msg));
}
