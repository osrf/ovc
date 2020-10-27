#!/usr/bin/env python3
from nmigen.back import verilog
from blink import *


top = Blink()
with open('top.v', 'w') as f:
    f.write(verilog.convert(top, ports=[top.led], strip_internal_attrs=True))
