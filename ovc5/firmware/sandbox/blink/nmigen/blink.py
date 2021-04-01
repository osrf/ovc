from nmigen import *


class Blink(Elaboratable):
    def __init__(self):
        self.led = Signal()
    def elaborate(self, platform):
        m = Module()
        counter = Signal(24)
        m.d.comb += self.led.eq(counter[23])
        m.d.sync += counter.eq(counter + 1)
        return m
