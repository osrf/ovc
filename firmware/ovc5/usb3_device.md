# USB3 SuperSpeed device mode on XU9

There's a lot going on here.
The USB3 device (Type B) connector is J600 on the ST1 board.
The SuperSpeed lanes are routed through a pair of MUXes, U700 and U703, which are controlled by the `USB_MODE0` and `USB_MODE1` DIP switches, respectively.

### `USB_MODE0` set to OFF
With `USB_MODE0` set to `OFF`, the `USB_MODE0` signal is HIGH, which means that the `USBD_SS*` lanes route to port C on U700, which is called `USBMOD_SS*`.
This becomes module pins A136/A140 (TX) and A137/A141 (RX).
These pins are unconnected on the XU9 module.

### `USB_MODE0` set to ON
With `USB_MODE0` set to `ON`, the `USB_MODE0` signal is LOW, which means that the `USBD_SSTX` lanes route to port B on U700, which is called `USBD0_SSTX`.
The `USBD0_SS*` lanes then route to U703.

#### `USB_MODE1` set to OFF
If the `USB_MODE1` DIP switch is OFF, then those signals become `USB0_SS*` and route to the module on pins B32/B36 (RX) and B29/B33 (TX).
Those module pins become FPGA pins H27/H28 (`MGTPS_RX2`) and J25/J26 (`MGTPS_TX2`)

#### `USB_MODE1` set to ON
TBD...

### Clocking
There is a 100 MHz GTR clock on K23/K24 this is `PS_MGTREFCLK2`.
