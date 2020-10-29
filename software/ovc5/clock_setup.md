# Clocking

### 10G PCS/PMA reference clock

We need a 156.25 MHz clock for the XGMII transceiver logic, which eventually feeds high-speed serial lanes from MGT BB TX3/RX3 on FPGA pins K6P/K5N (TX) and J4P/J3N (RX) to the SFP+ connector on the ST1 carrier board via module pins C63/C65 and C66/C68.
The XU9 module itself doesn't have an oscillator connected to the UltraScale+ GTH reference clock pins; instead, they bring those pins down to the carrier board.
On the ST1 carrier board, there is a [Si5338B-B-GMR](https://www.silabs.com/documents/public/data-sheets/Si5338.pdf) clock generator IC that has a single-ended 100M clock feeding pin `IN3`.
We need to generate a 156.25 Mhz differential clock on the Si5338B `CLK3 A/B` pins, which become `CLK_REF2 P/N` on the ST1, which becomes `MGT_BB_REFCLK0` on the XU9 board, finally going to FPGA pins L8P/L7N.

The Si5338B `I2C_LSB` pin is LOW on the ST1 board.

The chip is complex and generating a register set is most easily done with their GUI, [ClockBuilder Pro](https://www.silabs.com/products/development-tools/software/clockbuilder-pro-software) but unfortunately SiLabs has chosen (bizarrely) not to make a Linux version of this program (at time of writing, October 2020).
I made a noble attempt to get it working under `wine` with various combinations of Windows architecture (32/64 bit) and emulated Windows versions, but it would crash whenever you tried to actually open up a wizard and set inputs/outputs, etc., and I gave up. Great sadness.
