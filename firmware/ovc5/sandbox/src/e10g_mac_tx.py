from nmigen import *


class E10G_MAC_TX(Elaboratable):
    def __init__(self):
        self.counter = Signal(8)
        self.tx_d = Signal(64)
        self.tx_c = Signal(8)
    def elaborate(self, platform):
        m = Module()
        I = 0x07
        S = 0xfb
        T = 0xfd
        E = 0xfe
        ethertype = 0x0800
        #m.d.comb += self.led.eq(self.counter[2])
        m.d.sync += self.counter.eq(self.counter + 1)

        with m.FSM():
            with m.State('IDLE'):
                # todo: simplify this, move dmac/smac/type up to a UDP TX block
                with m.If(self.counter == 0x42):
                    m.next = 'DMAC'
                    m.d.sync += [
                        self.tx_d.eq(0xd5555555555555fb),
                        self.tx_c.eq(0x01)
                    ]
                with m.Else():
                    m.next = 'IDLE'
                    m.d.sync += [
                        self.tx_d.eq(0x0707070707070707),
                        self.tx_c.eq(0xff)
                    ]
            with m.State('DMAC'):
                m.next = 'SMAC'
                m.d.sync += [
                    self.tx_d.eq(0x3210ffffffffffff),
                    self.tx_c.eq(0x00)
                ]
            with m.State('SMAC'):
                m.next = 'PAYLOAD'
                m.d.sync += [
                    self.tx_d.eq(0x77770008ba987654),
                    self.tx_c.eq(0x00),
                    self.counter.eq(0)
                ]
            with m.State('PAYLOAD'):
                m.next = 'TERMINATE'
                m.d.sync += [
                    self.tx_d.eq(0x7777777777777777),
                    self.tx_c.eq(0x00)
                ]
            with m.State('TERMINATE'):
                m.next = 'IDLE'
                m.d.sync += [
                    self.tx_d.eq(0x07070707070707fd),
                    self.tx_c.eq(0xff),
                    self.counter.eq(0)
                ]

        return m
