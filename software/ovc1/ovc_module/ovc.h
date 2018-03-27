// this file is derived from altera_cvp.h
// original license: dual BSD / GPLv2
// released December 2017 by Open Robotics under the same license.
// original license copied below for clarity
//
/*
 * altera_cvp.h -- Altera CvP driver header file
 *
 * Written by: Altera Corporation <support@altera.com>
 *
 * Copyright (C) 2012 - 2015 Altera Corporation. All Rights Reserved.
 *
 * This file is provided under a dual BSD/GPLv2 license.  When using or
 * redistributing this file, you may do so under either license. The text of
 * the BSD license is provided below.
 *
 * BSD License
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 * derived from this software without specific prior written permission. 
 *
 * Alternatively, provided that this notice is retained in full, this software
 * may be distributed under the terms of the GNU General Public License ("GPL")
 * version 2, in which case the provisions of the GPL apply INSTEAD OF those
 * given above. A copy of the GPL may be found in the file GPLv2.txt provided
 * with this distribution in the same directory as this file.
 *
 * THIS SOFTWARE IS PROVIDED BY ALTERA CORPORATION "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#ifndef _JETCAM_H
#define _JETCAM_H

//#define JETCAM_CVP_DRIVER_NAME    "Jetcam"

#define NUM_VSEC_REGS           17 /* number of VSEC registers for CvP */
#define BYTES_IN_REG             4 /* number of bytes in each VSEC register */

#define ERR_CHK_INTERVAL      1024 /* only check for CRC errors every this many 32-bit words */
#define MIN_WAIT                 2 /* number of jiffies for unit wait period */
#define US_PER_JIFFY  (1000000/HZ) /* number of microseconds per jiffy */

#define OFFSET_VSEC          0x200 /* byte offset of VSEC register block for CvP */
#define OFFSET_CVP_STATUS     0x1E /* byte offsets of registers within VSEC */
#define OFFSET_CVP_MODE_CTRL  0x20
#define OFFSET_CVP_NUMCLKS    0X21
#define OFFSET_CVP_DATA       0x28
#define OFFSET_CVP_PROG_CTRL  0x2C
#define OFFSET_UNC_IE_STATUS  0x34

#define MASK_DATA_ENCRYPTED    0x01 /* bit 0 of CVP_STATUS */
#define MASK_DATA_COMPRESSED   0x02 /* bit 1 of CVP_STATUS */
#define MASK_CVP_CONFIG_READY  0x04 /* bit 2 of CVP_STATUS */
#define MASK_CVP_CONFIG_ERROR  0x08 /* bit 3 of CVP_STATUS */
#define MASK_CVP_EN            0x10 /* bit 4 of CVP_STATUS */
#define MASK_USER_MODE         0x20 /* bit 5 of CVP_STATUS */
#define MASK_PLD_CLK_IN_USE    0x01 /* bit 8 of CVP_STATUS (bit 0 of byte @ CVP_STATUS+1) */
#define MASK_CVP_MODE          0x01 /* bit 0 of CVP_MODE_CTRL */
#define MASK_HIP_CLK_SEL       0X02 /* bit 1 of CVP_MODE_CTRL */
#define MASK_CVP_CONFIG        0x01 /* bit 0 of CVP_PROG_CTRL */
#define MASK_START_XFER        0x02 /* bit 1 of CVP_PROG_CTRL */
#define MASK_CVP_CFG_ERR_LATCH 0x20 /* bit 5 of UNC_IE_STATUS */

#define OVC_DMA_BUF_SIZE (4*1024*1024)

struct ovc_cvp_dev {
	struct cdev cdev;         /* Char device structure */
	struct pci_dev *pci_dev;  /* PCI device structure handle */
	void __iomem *wr_addr;    /* Address to use for PCI memory writes */
  void __iomem *bar2_addr;  /* PIO output and input */
  void __iomem *bar3_addr;  /* IMU memory page */
  void __iomem *bar4_addr;  /* Generic register memory page */
	dev_t dev;                /* Major and minor numbers for char device */
	u8 remain[3];             /* Byte remainder from last write operation */
	char remain_size;         /* Number of bytes currently in remainder */
	atomic_t is_available;    /* Flag to enforce single-open */
  uint8_t *dma_buf;
  dma_addr_t dma_handle;
};

/* CvP bits */
enum {  DATA_ENCRYPTED = 0,
	DATA_COMPRESSED,
	CVP_CONFIG_READY,
	CVP_CONFIG_ERROR,
	CVP_EN,
	USER_MODE,
	PLD_CLK_IN_USE,
	CVP_MODE,
	HIP_CLK_SEL,
	CVP_CONFIG,
	START_XFER,
	CVP_CFG_ERR_LATCH
};

#endif /* _JETCAM_CVP_H */
