#!/usr/bin/env python3
from nmigen import *
from fcs import FCS


class XGMII_FCS_Inserter(Elaboratable):
    '''
    Adds a FCS to the XGMII data passing through
    '''

    def __init__(self):
        self.d_in = Signal(64)
        self.d_valid = Signal(8)
        self.d_out = Signal(64)
        self.c_out = Signal(8)
        self.fcs = FCS()

    def elaborate(self, platform):
        m = Module()

        # need to delay a few clocks for FCS pipeline stages
        d_in_d1 = Signal(64)
        d_in_d2 = Signal(64)
        d_in_d3 = Signal(64)

        d_valid_d1 = Signal(8)
        d_valid_d2 = Signal(8)
        d_valid_d3 = Signal(8)
        m.d.sync += [
            d_in_d1.eq(self.d_in),
            d_in_d2.eq(d_in_d1),
            d_in_d3.eq(d_in_d2),
            d_valid_d1.eq(self.d_valid),
            d_valid_d2.eq(d_valid_d1),
            d_valid_d3.eq(d_valid_d2)
        ]

        # output is self.fcs.crc
        fcs_clear = Signal()
        m.d.sync += fcs_clear.eq(False)

        m.submodules.fcs = self.fcs
        m.d.comb += [
            self.fcs.data.eq(self.d_in),
            self.fcs.clear.eq(fcs_clear),
            self.fcs.valid.eq(self.d_valid)
        ]

        fcs_clear.eq(False)  # todo

        with m.FSM():
            with m.State('IDLE'):
                with m.If(~self.d_valid[0]):
                    m.next = 'IDLE'
                    m.d.sync += fcs_clear.eq(True)
                with m.Else():
                    m.next = 'FCS_PIPELINE_DELAY'
                    m.d.sync += fcs_clear.eq(False)
                m.d.sync += [
                    self.d_out.eq(0x07070707_07070707),
                    self.c_out.eq(0xff)
                ]

            with m.State('FCS_PIPELINE_DELAY'):
                m.next = 'PREAMBLE'
                m.d.sync += [
                    self.d_out.eq(0x07070707_07070707),
                    self.c_out.eq(0xff)
                ]

            with m.State('PREAMBLE'):
                m.next = 'PAYLOAD'
                m.d.sync += [
                    self.d_out.eq(0xd5555555_555555fb),
                    self.c_out.eq(0x01)
                ]

            with m.State('PAYLOAD'):
                with m.If(d_valid_d3 == 0xff):
                    m.next = 'PAYLOAD'
                    m.d.sync += [
                        self.d_out.eq(d_in_d3),
                        self.c_out.eq(0x00)
                    ]
                with m.Elif(d_valid_d3 == 0x3f):
                    m.next = 'FCS'
                    m.d.sync += [
                        self.d_out.eq(Cat(d_in_d3[0:48], self.fcs.crc[0:16])),
                        self.c_out.eq(0x00)
                    ]
                with m.Else():  # the only other case handled here is 0x03
                    m.next = 'IDLE'
                    m.d.sync += [
                        self.d_out.eq(
                            Cat(
                                d_in_d3[0:16],
                                self.fcs.crc,
                                0x07fd  # terminate, back to idle pattern
                            )
                        ),
                        self.c_out.eq(0xc0)
                    ]

            with m.State('FCS'):
                m.next = 'IDLE'
                m.d.sync += [
                    self.d_out.eq(Cat(self.fcs.crc[16:32], 0x07070707_07fd)),
                    self.c_out.eq(0xfc)
                ]

        return m
