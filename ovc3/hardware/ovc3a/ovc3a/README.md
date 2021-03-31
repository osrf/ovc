# ovc3 early design concept

The idea for OVC3 is to dramatically reduce costs from OVC2 by using a
mass-produced high-density module for the FPGA/SoC, RAM, and so on. Ideally
this module will contain a Zynq UltraScale+ SoC with I/O that can function as a
USB3 transceiver.

Some candidate modules:
 * Trenz TE0820 (40mm x 50mm)
 * Trenz TE0803 / TE0808 (52mm x 76mm)
 * UltraZed
 * Enclustra Mercury

# Board Stack

For the smallest front cross-sectional area, it would be necessary to keep
the "sensor" and "compute" portions on separate boards. Unfortunately, this
would also increase small-quantity production costs.

Placing the compute module on the sensor board would make it larger/uglier,
but also keep costs down.
