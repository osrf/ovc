# ovc_embedded_driver

This is the ROS node that runs on the embedded Ubuntu on the OVC3 to interface between imagers / IMU and any additional hardware and the host system.
Currently it offers the following capabilities:

* Configuration and initialization of ICM-20948 IMU through SPI.
* Configuration of imagers through I2C.
* Synchronization between the two and timestamping.
* Configuration of FAST FPGA corner detector.
* Streaming of all data to ROS topics (IMU, images and corners).
