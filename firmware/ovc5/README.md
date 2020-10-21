# OVC5

Currently this concept is based on an Enclustra Mercury+ [XU9](https://www.enclustra.com/en/products/system-on-chip-modules/mercury-xu9/) module:
* Xilinx [XCZU4CG-1FBVB900E](https://www.xilinx.com/products/silicon-devices/soc/zynq-ultrascale-mpsoc.html) UltraScale+ MPSoC FPGA
  * dual-core ARM Cortex-A53 (64-bit)
  * dual-core ARM Cortex-R5 (32-bit)
  * two GbE interfaces
  * two USB 3.0 interfaces
  * two USB 2.0 interfaces (dual-role)
  * lots of low-speed peripherals for the ARM cores
  * 16 high-speed GTH transceivers (16 Gbit)
* 2 GB DDR4 ECC SDRAM for FPGA PS, 72-bit width
* 2 GB DDR4 SDRAM for FPGA PL, 64-bit width
* lots of "normal" I/O
* 64 MB QSPI flash
* 16 GB eMMC flash

### MIPI RX
The XU9 module's Zynq UltraScale+ FPGA is capable of "native" MIPI CSI reception without needing any external resistor networks.
