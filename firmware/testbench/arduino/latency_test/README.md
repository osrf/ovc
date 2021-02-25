# latency tester

This is a little Arduino gadget using the [Adafruit Feather M4 Express board](https://learn.adafruit.com/adafruit-feather-m4-express-atsamd51)

It just measures the time between and stop triggers, and prints the elapsed number of milliseconds to the virtual serial port.
The start trigger can be any of:
 * sending the character `A` (upper-case `A`) from the host to the device over the virtual serial port (for example, `/dev/ttyACM0`)
 * voltage on the `A0` pin above 1.0v (do not exceed the chip's max voltage of 3.3v)

The stop trigger is:
 * sending the character `a` (lower-case `a`) from the host to the device over the virtual serial port.
