from nmigen import *


class E10G_TX(Elaboratable):

    def __init__(self):
        self.xgmii_d = Signal(64)
        self.xgmii_c = Signal(8)
        # for now, assume dmac/smac are in network byte order already
        self.dmac = Signal(48)
        self.smac = Signal(48)
        self.ethertype = Signal(16)
        self.tx_en = Signal()
        self.tx_d = Signal(64)
        self.tx_d_d1 = Signal(64)
        self.tx_d_d2 = Signal(64)

    def elaborate(self, platform):
        m = Module()
        I = 0x07
        S = 0xfb
        T = 0xfd
        E = 0xfe
        #ethertype = 0x0800

        counter = Signal(8)
        m.d.sync += [
            counter.eq(counter + 1),
            self.tx_d_d1.eq(self.tx_d),
            self.tx_d_d2.eq(self.tx_d_d1)
        ]
        #m.d.comb += self.led.eq(self.counter[2])

        with m.FSM():
            with m.State('IDLE'):
                with m.If(~self.tx_en):  # keep sending IDLE
                    m.next = 'IDLE'
                    m.d.sync += [
                        self.xgmii_d.eq(0x0707070707070707),
                        self.xgmii_c.eq(0xff)
                    ]
                with m.Else():  # tx_en is asserted; let's start a packet!
                    m.next = 'DMAC'
                    m.d.sync += [
                        self.xgmii_d.eq(0xd5555555555555fb),
                        self.xgmii_c.eq(0x01)
                    ]
            with m.State('DMAC'):
                m.next = 'SMAC'
                m.d.sync += [
                    self.xgmii_d.eq(
                        self.dmac |
                        ((self.smac & 0xffff) << 48)),
                    self.xgmii_c.eq(0x00)
                ]
            with m.State('SMAC'):
                m.next = 'PAYLOAD'
                payload_start = 0x4242
                m.d.sync += [
                    self.xgmii_d.eq(
                        ((self.smac >> 16) & 0xffffffff) |
                        (self.ethertype << 32) |
                        (payload_start << 48)),
                    self.xgmii_c.eq(0x00),
                    counter.eq(0)
                ]
            with m.State('PAYLOAD'):
                m.next = 'TERMINATE'
                m.d.sync += [
                    self.xgmii_d.eq(0x7777777777777777), # todo: payload until it's empty
                    self.xgmii_c.eq(0x00)
                ]
            # todo: pad as necessary so that the frame is >= 64 bytes
            with m.State('TERMINATE'):
                m.next = 'IDLE'
                m.d.sync += [
                    self.xgmii_d.eq(0x07070707070707fd),
                    self.xgmii_c.eq(0xff),
                    counter.eq(0)
                ]

        return m
