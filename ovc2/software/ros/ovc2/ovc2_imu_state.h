#ifndef OVC_IMU_STATE_H_
#define OVC_IMU_STATE_H_

// that's a lot of capital letters, yo
class OVC2IMUState
{
public:
  float accel[3];
  float gyro[3];
  float temperature;
  float pressure;
  float quaternion[4];
  float mag_comp[3];

  OVC2IMUState()
  {
    accel[0] = accel[1] = accel[2] = 0;
    gyro[0] = gyro[1] = gyro[2] = 0;
    temperature = 0;
    pressure = 0;
    quaternion[0] = quaternion[1] = quaternion[2] = quaternion[3] = 0;
    mag_comp[0] = mag_comp[1] = mag_comp[2] = 0;
  }
};

#endif
