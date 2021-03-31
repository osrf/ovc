from nmigen import *


class Top(Elaboratable):
    def __init__(self):
        self.counter = Signal(3)
        self.led = Signal()
    def elaborate(self, platform):
        m = Module()
        m.d.comb += self.led.eq(self.counter[2])
        m.d.sync += self.counter.eq(self.counter + 1)
        return m
