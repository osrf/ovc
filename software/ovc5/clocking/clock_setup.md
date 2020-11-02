# Clocking

### 10G PCS/PMA reference clock

We need a 156.25 MHz clock for the XGMII transceiver logic, which eventually feeds high-speed serial lanes from MGT BB TX3/RX3 on FPGA pins K6P/K5N (TX) and J4P/J3N (RX) to the SFP+ connector on the ST1 carrier board via module pins C63/C65 and C66/C68.
The XU9 module itself doesn't have an oscillator connected to the UltraScale+ GTH reference clock pins; instead, they bring those pins down to the carrier board.
On the ST1 carrier board, there is a [Si5338B-B-GMR](https://www.silabs.com/documents/public/data-sheets/Si5338.pdf) clock generator IC that has a single-ended 100M clock feeding pin `IN3`.
We need to generate a 156.25 Mhz differential clock on the Si5338B `CLK3 A/B` pins, which become `CLK_REF2 P/N` on the ST1, which becomes `MGT_BB_REFCLK0` on the XU9 board, finally going to FPGA pins L8P/L7N.

The Si5338B `I2C_LSB` pin is LOW on the ST1 board.

The chip is complex and generating a register set is most easily done with their GUI, [ClockBuilder Pro](https://www.silabs.com/products/development-tools/software/clockbuilder-pro-software) but unfortunately SiLabs has chosen (bizarrely) not to make a Linux version of this program, at least at time of writing in October 2020.
I made a noble attempt to get it working under `wine` with various combinations of Windows architecture (32/64 bit) and emulated Windows versions, but it would crash whenever you tried to actually open up a wizard and set inputs/outputs, etc., and I gave up. Great sadness. Fortunately a kind colleague with a Windows machine loaded up ClockBuilder Pro and generated the registers.

### instantiating the PCS/PMA subsystem
Unfortunately the clock routes for this output of the clock generator on the ST1 are fully buried underneath the XU9 module, so it seems that we have to instantiate the PCS/PMA subsystem on the Zynq in order to route it back out another pin.
The SFP+ interface goes to FPGA transceiver pads K6/K5 and J3/J4, which is labeled as "Quad 224" in the pinout PDF. Our clock in L7/L8 also goes to this quad.
The 10G/25G block IP configuration tool wants the quad defined in XY, not quad number.
If I'm parsing Figure 1-8 correctly in UG1075 (page 48), it appears that Quad 224 is Quad X0Y1, with channels X0Y4-X0Y7, so TX3/RX3 in that quad is X0Y7.
