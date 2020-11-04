from nmigen import *


class E10G_TX(Elaboratable):

    def __init__(self):
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)
        self.dmac = Signal(48)
        self.smac = Signal(48)
        self.ethertype = Signal(16)
        self.tx_d = Signal(64)
        self.tx_en = Signal()

    def elaborate(self, platform):
        m = Module()
        I = 0x07
        S = 0xfb
        T = 0xfd
        E = 0xfe
        #ethertype = 0x0800

        counter = Signal(8)
        m.d.sync += counter.eq(counter + 1)
        #m.d.comb += self.led.eq(self.counter[2])

        with m.FSM():
            with m.State('IDLE'):
                # todo: simplify this, move dmac/smac/type up to a UDP TX block
                with m.If(self.tx_en):
                    m.next = 'DMAC'
                    m.d.sync += [
                        self.xgmii_d.eq(0xd5555555555555fb),
                        self.xgmii_c.eq(0x01)
                    ]
                with m.Else():
                    m.next = 'IDLE'
                    m.d.sync += [
                        self.xgmii_d.eq(0x0707070707070707),
                        self.xgmii_c.eq(0xff)
                    ]
            with m.State('DMAC'):
                m.next = 'SMAC'
                m.d.sync += [
                    self.xgmii_d.eq(0x3210ffffffffffff), # todo: concat dmac+smac[11:0]
                    self.xgmii_c.eq(0x00)
                ]
            with m.State('SMAC'):
                m.next = 'PAYLOAD'
                m.d.sync += [
                    self.xgmii_d.eq(0x77770008ba987654), # todo: concat smac[47:12], ethertype, and first 16 bits payload
                    self.xgmii_c.eq(0x00),
                    counter.eq(0)
                ]
            with m.State('PAYLOAD'):
                m.next = 'TERMINATE'
                m.d.sync += [
                    self.xgmii_d.eq(0x7777777777777777), # todo: payload until it's empty
                    self.xgmii_c.eq(0x00)
                ]
            with m.State('TERMINATE'):
                m.next = 'IDLE'
                m.d.sync += [
                    self.xgmii_d.eq(0x07070707070707fd),
                    self.xgmii_c.eq(0xff),
                    counter.eq(0)
                ]

        return m
