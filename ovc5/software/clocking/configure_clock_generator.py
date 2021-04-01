#!/usr/bin/env python3
import smbus
import sys
from time import sleep


SI5338_DEV_ADDR = 0x70


SI5338_CONFIG = [
    (  6, 0x08),  # mask bit for loss of signal (not needed?)
    ( 27, 0x00),  # confirm that reference voltage is 3.3v (not needed?)
    ( 28, 0x0b),  # use clock input IN3
    ( 29, 0x4a),  # use divide IN3 by 4, use P1DIV_OUT
    ( 30, 0xb0),  # no PDF_IN_FB, no clock into P2 divider
    ( 31, 0xe3),  # no clock into R0 divider, power down CLK0 driver
    ( 32, 0xe3),  # no clock into R1 divider, power down CLK1 driver
    ( 33, 0xe3),  # no clock into R2 divider, power down CLK2 driver
    ( 34, 0xc0),  # use MultiSynth3 output, set R3 divider to 1, power up CLK3
    ( 35, 0x00),  # all VDDO are connected to 3v3 on the board
    ( 36, 0x00),  # CLK0 is powered down
    ( 37, 0x00),  # CLK1 is powered down
    ( 38, 0x00),  # CLK2 is powered down
    ( 39, 0x06),  # CLK3 is LVDS
    ( 40, 0x63),  # trim bits, set by ClockBuilder
    ( 41, 0x0c),  # trim bits, set by ClockBuilder
    ( 42, 0x23),  # trim bits, set by ClockBuilder
    ( 45, 0x00),  # frequency calibration override (?)
    ( 46, 0x00),  # frequency calibration override (?)
    ( 47, 0x14),  # frequency calibration override (?)
    ( 48, 0x3A),  # internal feedback path, charge pump current (ClockBuilder)
    ( 49, 0x00),  # do not use frequency calibration override
    ( 50, 0xC4),  # enable PLL, use calibration (ClockBuilder)
    ( 51, 0x07),  # multisynch phase error correction
    ( 52, 0x10),  # disable frequency inc/dec on MS0
    ( 53, 0x00),  # MS0 params
    ( 54, 0x00),  # MS0 params
    ( 55, 0x00),  # MS0 params
    ( 56, 0x00),  # MS0 params
    ( 57, 0x00),  # MS0 params
    ( 58, 0x00),  # MS0 params
    ( 59, 0x00),  # MS0 params
    ( 60, 0x00),  # MS0 params
    ( 61, 0x00),  # MS0 params
    ( 62, 0x00),  # MS0 params
    ( 63, 0x10),  # MS1 disable inc/dec
    ( 64, 0x00),  # MS1 params
    ( 65, 0x00),  # MS1 params
    ( 66, 0x00),  # MS1 params
    ( 67, 0x00),  # MS1 params
    ( 68, 0x00),  # MS1 params
    ( 69, 0x00),  # MS1 params
    ( 70, 0x00),  # MS1 params
    ( 71, 0x00),  # MS1 params
    ( 72, 0x00),  # MS1 params
    ( 73, 0x00),  # MS1 params
    ( 74, 0x10),  # MS2 disable inc/dec
    ( 75, 0x00),  # MS2 params
    ( 76, 0x00),  # MS2 params
    ( 77, 0x00),  # MS2 params
    ( 78, 0x00),  # MS2 params
    ( 79, 0x00),  # MS2 params
    ( 80, 0x00),  # MS2 params
    ( 81, 0x00),  # MS2 params
    ( 82, 0x00),  # MS2 params
    ( 83, 0x00),  # MS2 params
    ( 84, 0x00),  # MS2 params
    ( 85, 0x10),  # MS3 disable inc/dec
    ( 86, 0x00),  # MS3 params
    ( 87, 0x06),  # MS3 params
    ( 88, 0x00),  # MS3 params
    ( 89, 0x00),  # MS3 params
    ( 90, 0x00),  # MS3 params
    ( 91, 0x00),  # MS3 params
    ( 92, 0x01),  # MS3 params
    ( 93, 0x00),  # MS3 params
    ( 94, 0x00),  # MS3 params
    ( 95, 0x00),  # MS3 params
    ( 97, 0x00),  # MSN params
    ( 98, 0x30),  # MSN params
    ( 99, 0x00),  # MSN params
    (100, 0x00),  # MSN params
    (101, 0x00),  # MSN params
    (102, 0x00),  # MSN params
    (103, 0x01),  # MSN params
    (104, 0x00),  # MSN params
    (105, 0x00),  # MSN params
    (106, 0x80),  # MSN params
    (107, 0x00),  # MS0 phase offset
    (108, 0x00),  # MS0 phase offset
    (109, 0x00),  # MS0 phase step size
    (110, 0x40),  # clk0 output LOW when disabled
    (111, 0x00),  # MS1 phase offset
    (112, 0x00),  # MS1 phase offset
    (113, 0x00),  # MS1 phase step size
    (114, 0x40),  # CLK1 output LOW when disabled
    (115, 0x00),  # MS2 phase offset
    (116, 0x80),  # MS2 phase offset
    (117, 0x00),  # MS2 phase step size
    (118, 0x40),  # CLK2 output LOW when disabled
    (119, 0x00),  # MS3 phase offset
    (120, 0x00),  # MS3 phase offset
    (121, 0x00),  # MS3 phase step size
    (122, 0x00),  # CLK3 output high-Z when disabled
    (123, 0x00),  # MS0 inc/dec params
    (124, 0x00),  # MS0 inc/dec parmas
    (125, 0x00),  # MS0 inc/dec params
    (126, 0x00),  # MS0 inc/dec params
    (127, 0x00),  # MS0 inc/dec params
    (128, 0x00),  # MS0 inc/dec params
    (129, 0x00),  # MS0 inc/dec params
    (130, 0x00),  # MS0 inc/dec params
    (131, 0x00),  # MS0 inc/dec params
    (132, 0x00),  # MS0 inc/dec params
    (133, 0x00),  # MS0 inc/dec params
    (134, 0x00),  # MS0 inc/dec params
    (135, 0x00),  # MS0 inc/dec params
    (136, 0x00),  # MS0 inc/dec params
    (137, 0x00),  # MS0 inc/dec params
    (138, 0x00),  # MS0 inc/dec params
    (139, 0x00),  # MS0 inc/dec params
    (140, 0x00),  # MS0 inc/dec params
    (141, 0x00),  # MS0 inc/dec params
    (142, 0x00),  # MS0 inc/dec params
    (143, 0x00),  # MS0 inc/dec params
    (144, 0x00),  # MS0 inc/dec params
    (152, 0x00),  # MS1 inc/dec params
    (153, 0x00),  # MS1 inc/dec params
    (154, 0x00),  # MS1 inc/dec params
    (155, 0x00),  # MS1 inc/dec params
    (156, 0x00),  # MS1 inc/dec params
    (157, 0x00),  # MS1 inc/dec params
    (158, 0x00),  # MS1 inc/dec params
    (159, 0x00),  # MS1 inc/dec params
    (160, 0x00),  # MS1 inc/dec params
    (161, 0x00),  # MS1 inc/dec params
    (162, 0x00),  # MS1 inc/dec params
    (163, 0x00),  # MS1 inc/dec params
    (164, 0x00),  # MS1 inc/dec params
    (165, 0x00),  # MS1 inc/dec params
    (166, 0x00),  # MS1 inc/dec params
    (167, 0x00),  # MS1 inc/dec params
    (168, 0x00),  # MS1 inc/dec params
    (169, 0x00),  # MS1 inc/dec params
    (170, 0x00),  # MS1 inc/dec params
    (171, 0x00),  # MS1 inc/dec params
    (172, 0x00),  # MS1 inc/dec params
    (173, 0x00),  # MS1 inc/dec params
    (174, 0x00),  # MS2 inc/dec params
    (175, 0x00),  # MS2 inc/dec params
    (176, 0x00),  # MS2 inc/dec params
    (177, 0x00),  # MS2 inc/dec params
    (178, 0x00),  # MS2 inc/dec params
    (179, 0x00),  # MS2 inc/dec params
    (180, 0x00),  # MS2 inc/dec params
    (181, 0x00),  # MS2 inc/dec params
    (182, 0x00),  # MS2 inc/dec params
    (183, 0x00),  # MS2 inc/dec params
    (184, 0x00),  # MS2 inc/dec params
    (185, 0x00),  # MS2 inc/dec params
    (186, 0x00),  # MS2 inc/dec params
    (187, 0x00),  # MS2 inc/dec params
    (188, 0x00),  # MS2 inc/dec params
    (189, 0x00),  # MS2 inc/dec params
    (190, 0x00),  # MS2 inc/dec params
    (191, 0x00),  # MS2 inc/dec params
    (192, 0x00),  # MS2 inc/dec params
    (193, 0x00),  # MS2 inc/dec params
    (194, 0x00),  # MS2 inc/dec params
    (195, 0x00),  # MS2 inc/dec params
    (196, 0x00),  # MS3 inc/dec params
    (197, 0x00),  # MS3 inc/dec params
    (198, 0x00),  # MS3 inc/dec params
    (199, 0x00),  # MS3 inc/dec params
    (200, 0x00),  # MS3 inc/dec params
    (201, 0x00),  # MS3 inc/dec params
    (202, 0x00),  # MS3 inc/dec params
    (203, 0x00),  # MS3 inc/dec params
    (204, 0x00),  # MS3 inc/dec params
    (205, 0x00),  # MS3 inc/dec params
    (206, 0x00),  # MS3 inc/dec params
    (207, 0x00),  # MS3 inc/dec params
    (208, 0x00),  # MS3 inc/dec params
    (209, 0x00),  # MS3 inc/dec params
    (210, 0x00),  # MS3 inc/dec params
    (211, 0x00),  # MS3 inc/dec params
    (212, 0x00),  # MS3 inc/dec params
    (213, 0x00),  # MS3 inc/dec params
    (214, 0x00),  # MS3 inc/dec params
    (215, 0x00),  # MS3 inc/dec params
    (216, 0x00),  # MS3 inc/dec params
    (217, 0x00),  # MS3 inc/dec params
    (230, 0x07),  # disable CLK0, CLK1, CLK2. enable CLK3
    (287, 0x00),  # MS0 spread spectrum params
    (288, 0x00),  # MS0 spread spectrum params
    (289, 0x01),  # MS0 spread spectrum params
    (290, 0x00),  # MS0 spread spectrum params
    (291, 0x00),  # MS0 spread spectrum params
    (292, 0x90),  # MS0 spread spectrum params
    (293, 0x31),  # MS0 spread spectrum params
    (294, 0x00),  # MS0 spread spectrum params
    (295, 0x00),  # MS0 spread spectrum params
    (296, 0x01),  # MS0 spread spectrum params
    (297, 0x00),  # MS0 spread spectrum params
    (298, 0x00),  # MS0 spread spectrum params
    (299, 0x00),  # MS0 spread spectrum params
    (303, 0x00),  # MS1 spread spectrum params
    (304, 0x00),  # MS1 spread spectrum params
    (305, 0x01),  # MS1 spread spectrum params
    (306, 0x00),  # MS1 spread spectrum params
    (307, 0x00),  # MS1 spread spectrum params
    (308, 0x90),  # MS1 spread spectrum params
    (309, 0x31),  # MS1 spread spectrum params
    (310, 0x00),  # MS1 spread spectrum params
    (311, 0x00),  # MS1 spread spectrum params
    (312, 0x01),  # MS1 spread spectrum params
    (313, 0x00),  # MS1 spread spectrum params
    (314, 0x00),  # MS1 spread spectrum params
    (315, 0x00),  # MS1 spread spectrum params
    (319, 0x00),  # MS2 spread spectrum params
    (320, 0x00),  # MS2 spread spectrum params
    (321, 0x01),  # MS2 spread spectrum params
    (322, 0x00),  # MS2 spread spectrum params
    (323, 0x00),  # MS2 spread spectrum params
    (324, 0x90),  # MS2 spread spectrum params
    (325, 0x31),  # MS2 spread spectrum params
    (326, 0x00),  # MS2 spread spectrum params
    (327, 0x00),  # MS2 spread spectrum params
    (328, 0x01),  # MS2 spread spectrum params
    (329, 0x00),  # MS2 spread spectrum params
    (330, 0x00),  # MS2 spread spectrum params
    (331, 0x00),  # MS2 spread spectrum params
    (335, 0x00),  # MS3 spread spectrum params
    (336, 0x00),  # MS3 spread spectrum params
    (337, 0x00),  # MS3 spread spectrum params
    (338, 0x00),  # MS3 spread spectrum params
    (339, 0x00),  # MS3 spread spectrum params
    (340, 0x90),  # MS3 spread spectrum params
    (341, 0x31),  # MS3 spread spectrum params
    (342, 0x00),  # MS3 spread spectrum params
    (343, 0x00),  # MS3 spread spectrum params
    (344, 0x01),  # MS3 spread spectrum params
    (345, 0x00),  # MS3 spread spectrum params
    (346, 0x00),  # MS3 spread spectrum params
    (347, 0x00),  # MS3 spread spectrum params
]


def si5338_set_page(bus, reg_addr):
    if reg_addr >= 256:
        page_idx = 1
    else:
        page_idx = 0
    bus.write_byte_data(SI5338_DEV_ADDR, 255, page_idx)


def si5338_translate_addr(reg_addr):
    if reg_addr >= 256:
        return reg_addr - 256
    else:
        return reg_addr


def si5338_write_allowed_mask(reg_addr):
    masks = [
        (  0, 0x00),
        (  1, 0x00),
        (  2, 0x00),
        (  3, 0x00),
        (  4, 0x00),
        (  5, 0x00),
        (  6, 0x1D),
        (  7, 0x00),
        (  8, 0x00),
        (  9, 0x00),
        ( 10, 0x00),
        ( 11, 0x00),
        ( 12, 0x00),
        ( 13, 0x00),
        ( 14, 0x00),
        ( 15, 0x00),
        ( 16, 0x00),
        ( 17, 0x00),
        ( 18, 0x00),
        ( 19, 0x00),
        ( 20, 0x00),
        ( 21, 0x00),
        ( 22, 0x00),
        ( 23, 0x00),
        ( 24, 0x00),
        ( 25, 0x00),
        ( 26, 0x00),
        ( 27, 0x80),
        ( 28, 0xFF),
        ( 29, 0xFF),
        ( 30, 0xFF),
        ( 31, 0xFF),
        ( 32, 0xFF),
        ( 33, 0xFF),
        ( 34, 0xFF),
        ( 35, 0xFF),
        ( 36, 0x1F),
        ( 37, 0x1F),
        ( 38, 0x1F),
        ( 39, 0x1F),
        ( 40, 0xFF),
        ( 41, 0x7F),
        ( 42, 0x3F),
        ( 43, 0x00),
        ( 44, 0x00),
        ( 45, 0xFF),
        ( 46, 0xFF),
        ( 47, 0xFF),
        ( 48, 0xFF),
        ( 49, 0xFF),
        ( 50, 0xFF),
        ( 51, 0xFF),
        ( 52, 0x7F),
        ( 53, 0xFF),
        ( 54, 0xFF),
        ( 55, 0xFF),
        ( 56, 0xFF),
        ( 57, 0xFF),
        ( 58, 0xFF),
        ( 59, 0xFF),
        ( 60, 0xFF),
        ( 61, 0xFF),
        ( 62, 0x3F),
        ( 63, 0x7F),
        ( 64, 0xFF),
        ( 65, 0xFF),
        ( 66, 0xFF),
        ( 67, 0xFF),
        ( 68, 0xFF),
        ( 69, 0xFF),
        ( 70, 0xFF),
        ( 71, 0xFF),
        ( 72, 0xFF),
        ( 73, 0x3F),
        ( 74, 0x7F),
        ( 75, 0xFF),
        ( 76, 0xFF),
        ( 77, 0xFF),
        ( 78, 0xFF),
        ( 79, 0xFF),
        ( 80, 0xFF),
        ( 81, 0xFF),
        ( 82, 0xFF),
        ( 83, 0xFF),
        ( 84, 0x3F),
        ( 85, 0x7F),
        ( 86, 0xFF),
        ( 87, 0xFF),
        ( 88, 0xFF),
        ( 89, 0xFF),
        ( 90, 0xFF),
        ( 91, 0xFF),
        ( 92, 0xFF),
        ( 93, 0xFF),
        ( 94, 0xFF),
        ( 95, 0x3F),
        ( 96, 0x00),
        ( 97, 0xFF),
        ( 98, 0xFF),
        ( 99, 0xFF),
        (100, 0xFF),
        (101, 0xFF),
        (102, 0xFF),
        (103, 0xFF),
        (104, 0xFF),
        (105, 0xFF),
        (106, 0xBF),
        (107, 0xFF),
        (108, 0x7F),
        (109, 0xFF),
        (110, 0xFF),
        (111, 0xFF),
        (112, 0x7F),
        (113, 0xFF),
        (114, 0xFF),
        (115, 0xFF),
        (116, 0xFF),
        (117, 0xFF),
        (118, 0xFF),
        (119, 0xFF),
        (120, 0xFF),
        (121, 0xFF),
        (122, 0xFF),
        (123, 0xFF),
        (124, 0xFF),
        (125, 0xFF),
        (126, 0xFF),
        (127, 0xFF),
        (128, 0xFF),
        (129, 0x0F),
        (130, 0x0F),
        (131, 0xFF),
        (132, 0xFF),
        (133, 0xFF),
        (134, 0xFF),
        (135, 0xFF),
        (136, 0xFF),
        (137, 0xFF),
        (138, 0xFF),
        (139, 0xFF),
        (140, 0xFF),
        (141, 0xFF),
        (142, 0xFF),
        (143, 0xFF),
        (144, 0xFF),
        (145, 0x00),
        (146, 0x00),
        (147, 0x00),
        (148, 0x00),
        (149, 0x00),
        (150, 0x00),
        (151, 0x00),
        (152, 0xFF),
        (153, 0xFF),
        (154, 0xFF),
        (155, 0xFF),
        (156, 0xFF),
        (157, 0xFF),
        (158, 0x0F),
        (159, 0x0F),
        (160, 0xFF),
        (161, 0xFF),
        (162, 0xFF),
        (163, 0xFF),
        (164, 0xFF),
        (165, 0xFF),
        (166, 0xFF),
        (167, 0xFF),
        (168, 0xFF),
        (169, 0xFF),
        (170, 0xFF),
        (171, 0xFF),
        (172, 0xFF),
        (173, 0xFF),
        (174, 0xFF),
        (175, 0xFF),
        (176, 0xFF),
        (177, 0xFF),
        (178, 0xFF),
        (179, 0xFF),
        (180, 0xFF),
        (181, 0x0F),
        (182, 0xFF),
        (183, 0xFF),
        (184, 0xFF),
        (185, 0xFF),
        (186, 0xFF),
        (187, 0xFF),
        (188, 0xFF),
        (189, 0xFF),
        (190, 0xFF),
        (191, 0xFF),
        (192, 0xFF),
        (193, 0xFF),
        (194, 0xFF),
        (195, 0xFF),
        (196, 0xFF),
        (197, 0xFF),
        (198, 0xFF),
        (199, 0xFF),
        (200, 0xFF),
        (201, 0xFF),
        (202, 0xFF),
        (203, 0x0F),
        (204, 0xFF),
        (205, 0xFF),
        (206, 0xFF),
        (207, 0xFF),
        (208, 0xFF),
        (209, 0xFF),
        (210, 0xFF),
        (211, 0xFF),
        (212, 0xFF),
        (213, 0xFF),
        (214, 0xFF),
        (215, 0xFF),
        (216, 0xFF),
        (217, 0xFF),
        (218, 0x00),
        (219, 0x00),
        (220, 0x00),
        (221, 0x00),
        (222, 0x00),
        (223, 0x00),
        (224, 0x00),
        (225, 0x00),
        (226, 0x04),
        (227, 0x00),
        (228, 0x00),
        (229, 0x00),
        (230, 0xFF),
        (231, 0x00),
        (232, 0x00),
        (233, 0x00),
        (234, 0x00),
        (235, 0x00),
        (236, 0x00),
        (237, 0x00),
        (238, 0x00),
        (239, 0x00),
        (240, 0x00),
        (241, 0xFF),
        (242, 0x02),
        (243, 0x00),
        (244, 0x00),
        (245, 0x00),
        (246, 0xFF),
        (247, 0x00),
        (248, 0x00),
        (249, 0x00),
        (250, 0x00),
        (251, 0x00),
        (252, 0x00),
        (253, 0x00),
        (254, 0x00),
        (255, 0xFF),
        (256, 0x00),
        (257, 0x00),
        (258, 0x00),
        (259, 0x00),
        (260, 0x00),
        (261, 0x00),
        (262, 0x00),
        (263, 0x00),
        (264, 0x00),
        (265, 0x00),
        (266, 0x00),
        (267, 0x00),
        (268, 0x00),
        (269, 0x00),
        (270, 0x00),
        (271, 0x00),
        (272, 0x00),
        (273, 0x00),
        (274, 0x00),
        (275, 0x00),
        (276, 0x00),
        (277, 0x00),
        (278, 0x00),
        (279, 0x00),
        (280, 0x00),
        (281, 0x00),
        (282, 0x00),
        (283, 0x00),
        (284, 0x00),
        (285, 0x00),
        (286, 0x00),
        (287, 0xFF),
        (288, 0xFF),
        (289, 0xFF),
        (290, 0xFF),
        (291, 0xFF),
        (292, 0xFF),
        (293, 0xFF),
        (294, 0xFF),
        (295, 0xFF),
        (296, 0xFF),
        (297, 0xFF),
        (298, 0xFF),
        (299, 0x0F),
        (300, 0x00),
        (301, 0x00),
        (302, 0x00),
        (303, 0xFF),
        (304, 0xFF),
        (305, 0xFF),
        (306, 0xFF),
        (307, 0xFF),
        (308, 0xFF),
        (309, 0xFF),
        (310, 0xFF),
        (311, 0xFF),
        (312, 0xFF),
        (313, 0xFF),
        (314, 0xFF),
        (315, 0x0F),
        (316, 0x00),
        (317, 0x00),
        (318, 0x00),
        (319, 0xFF),
        (320, 0xFF),
        (321, 0xFF),
        (322, 0xFF),
        (323, 0xFF),
        (324, 0xFF),
        (325, 0xFF),
        (326, 0xFF),
        (327, 0xFF),
        (328, 0xFF),
        (329, 0xFF),
        (330, 0xFF),
        (331, 0x0F),
        (332, 0x00),
        (333, 0x00),
        (334, 0x00),
        (335, 0xFF),
        (336, 0xFF),
        (337, 0xFF),
        (338, 0xFF),
        (339, 0xFF),
        (340, 0xFF),
        (341, 0xFF),
        (342, 0xFF),
        (343, 0xFF),
        (344, 0xFF),
        (345, 0xFF),
        (346, 0xFF),
        (347, 0x0F),
        (348, 0x00),
        (349, 0x00),
        (350, 0x00),
    ]
    for m in masks:
        if m[0] == reg_addr:
            return m[1]
    # if we get here, that means we didn't find one... bogus addr :(
    raise Exception("bad address! no mask!")


def si5338_set_register(bus, reg_addr, reg_val, set_page=True):
    if set_page:
        si5338_set_page(bus, reg_addr)

    mask = si5338_write_allowed_mask(reg_addr)
    #print(f'reg {reg_addr} mask = 0x{mask:02x}')

    if mask == 0xff:
        bus.write_byte_data(
            SI5338_DEV_ADDR,
            si5338_translate_addr(reg_addr),
            reg_val)
    else:
        # have to do a read-modify-write
        prev_val = si5338_get_register(bus, reg_addr, False)
        masked_prev_val = prev_val & ~mask
        masked_new_val = reg_val & mask
        bus.write_byte_data(
            SI5338_DEV_ADDR,
            si5338_translate_addr(reg_addr),
            masked_prev_val | masked_new_val)


def si5338_get_register(bus, reg_addr, set_page=True):
    if set_page:
        si5338_set_page(bus, reg_addr)

    return bus.read_byte_data(
        SI5338_DEV_ADDR,
        si5338_translate_addr(reg_addr))


def si5338_print_register(bus, reg_addr):
    val = si5338_get_register(bus, reg_addr)
    print(f'reg {reg_addr}: 0x{val:02x}')


def configure_clock_generator():
    bus = smbus.SMBus(0)  # clock generator is on the first i2c bus

    reg0 = si5338_get_register(bus, 0)  #bus.read_byte_data(SI5338_DEV_ADDR, 0)
    if reg0 != 1:
        print(f'unexpected value for Si5338 reg 0: {reg0}')
        sys.exit(1)

    print(f'successfully read Si5338 version register: {reg0}')

    # disable all outputs
    si5338_set_register(bus, 230, 0x10)

    # pause LOL by asserting high bit of reg 241
    si5338_set_register(bus, 241, 0xe5)

    # populate register table
    #si5338_set_register(bus, 2
    for reg in SI5338_CONFIG:
        reg_addr = reg[0]
        reg_val = reg[1]
        si5338_set_register(bus, reg_addr, reg_val)

    si5338_set_register(bus, 246, 0x02)  # start soft reset
    sleep(0.025)  # sleep at least 25ms

    # restart LOL
    si5338_set_register(bus, 241, 0x65)

    # check lock bits
    for i in range(0, 100):
        status = si5338_get_register(bus, 218)
        if status == 0x08:
            print('PLL locked, hooray')
            break
        else:
            print('waiting for lock...')

    # copy FCAL to active registers
    si5338_print_register(bus, 237)
    si5338_print_register(bus, 236)
    si5338_print_register(bus, 235)
    si5338_set_register(bus, 47, si5338_get_register(bus, 237) & 0x3)
    si5338_set_register(bus, 46, si5338_get_register(bus, 236))
    si5338_set_register(bus, 45, si5338_get_register(bus, 235))

    # enable FCAL
    si5338_set_register(bus, 49, si5338_get_register(bus, 49) | 0x80)

    # turn off global clock disable
    si5338_set_register(bus, 230, si5338_get_register(bus, 230) & ~0x10)

    # sanity check a few values
    si5338_print_register(bus, 230)
    si5338_print_register(bus, 218)

    # JUST FOR TESTING: power consumption: disable all clocks
    # si5338_set_register(bus, 230, 0xf)


if __name__ == '__main__':
    configure_clock_generator()
