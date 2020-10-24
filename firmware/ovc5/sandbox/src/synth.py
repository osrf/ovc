#!/usr/bin/env python3
from nmigen.back import verilog
from e10g_tx import *


top = E10G_TX()
with open('top.v', 'w') as f:
    f.write(verilog.convert(top, ports=[]))
