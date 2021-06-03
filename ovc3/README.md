# OVC 3 overview
OVC3 includes a Zynq Ultrascale+ SoC, with a quad core ARM application processor, two real time cores and FPGA fabric.
Currently the real time cores are not used, the quad core processor runs a full Ubuntu 18.04 distribution with ROS melodic and the FPGA fabric runs the interfaces to the imagers (through MIPI / I2C), the IMU (SPI) and the DMA to write data to external memory.

# Version notes

There are currently two versions of the OVC3
 - OVC3a: this is the old version of the OVC3. **Do not use unless you know what you are doing**. The firmware does not support this board, and you may damage your hardware.
 - OVC3b: most recent version of the OVC3. Changes compared to OVC3a:
   - Various hardware fixes. See `ovc/ovc3/hardware/ovc3a/ovc3a/camera/FIXME`
   - VectorNav carrier is mounted in the front of the platform.
   - More GPIO for the backpack.

