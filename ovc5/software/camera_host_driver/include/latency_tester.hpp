#include <string>


class LatencyTester
{
private:
  int serial_port; 


public:
  LatencyTester(const std::string& file = "/dev/ttyACM0");

  void frameReceived();

};
