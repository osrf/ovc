#!/usr/bin/env python3
from nmigen.back import verilog
from packet_blaster import PacketBlaster


pb = PacketBlaster(0x100_0000)
with open('packet_blaster.v', 'w') as f:
    f.write(verilog.convert(pb, ports=[pb.xgmii_d, pb.xgmii_c], strip_internal_attrs=True))
