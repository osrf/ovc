# Clocking

### 10G PCS/PMA reference clock

We need a 156.25 MHz clock for the XGMII transceiver logic, which eventually feeds high-speed serial lanes from MGT BB TX3/RX3 on FPGA pins K6P/K5N (TX) and J4P/J3N (RX) to the SFP+ connector on the ST1 carrier board via module pins C63/C65 and C66/C68.
The XU9 module itself doesn't have an oscillator connected to the UltraScale+ GTH reference clock pins; instead, they bring those pins down to the carrier board.
On the ST1 carrier board, there is a Si5338B-B-GMR clock generator IC that has a single-ended 100M clock feeding it on `IN3`.
We need to generate a 156.25 Mhz differential clock on the Si5338B `CLK3 A/B` pins, which become `CLK_REF2 P/N` on the ST1, then `MGT_BB_REFCLK0` on the XU9 board, FPGA pins L8P/L7N.
