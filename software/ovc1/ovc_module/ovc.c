// this file is derived from altera_cvp.h
// original license: dual BSD / GPLv2
// released December 2017 by Open Robotics under the same license.
// original license copied below for clarity
//
/*
 * altera_cvp.c -- Configuration driver for Altera CvP-capable FPGAs
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

#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/device.h> /* dev_err(), etc. */
#include <linux/pci.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <linux/cdev.h>
#include <asm/uaccess.h> /* copy_to/from_user */
#include <linux/slab.h>  /* kmalloc */
#include <linux/ktime.h>
#include <linux/delay.h>
#include <linux/types.h>
#include <linux/dma-mapping.h>
#include <linux/mm.h>
#include <linux/wait.h>
#include <linux/completion.h>
#include <asm/spinlock.h>

#include "ovc.h"
#include "ovc_ioctl.h"

/* PCIe Vendor & Device IDs are parameters passed to the module when it's loaded */
static unsigned short vid = 0x1234; /* placeholder VID */
static unsigned short did = 0x5678; /* placeholder PID */
module_param(vid, ushort, S_IRUGO);
module_param(did, ushort, S_IRUGO);

static struct completion image_dma_done, imu_done;
DEFINE_SPINLOCK(pio_spinlock);
//static spinlock_t pio_spinlock;

struct ovc_cvp_dev cvp_dev; /* contents initialized in altera_cvp_init() */
static unsigned int altera_cvp_major; /* major number to use */

static ktime_t t_dma_start; // t_dma_stop;
/* CvP helper functions */

static int altera_cvp_get_offset_and_mask(int bit, int *byte_offset, u8 *mask)
{
	switch (bit) {
		case DATA_ENCRYPTED:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS;
			*mask = MASK_DATA_ENCRYPTED;
			break;
		case DATA_COMPRESSED:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS;
			*mask = MASK_DATA_COMPRESSED;
			break;
		case CVP_CONFIG_READY:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS;
			*mask = MASK_CVP_CONFIG_READY;
			break;
		case CVP_CONFIG_ERROR:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS;
			*mask = MASK_CVP_CONFIG_ERROR;
			break;
		case CVP_EN:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS;
			*mask = MASK_CVP_EN;
			break;
		case USER_MODE:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS;
			*mask =  MASK_USER_MODE;
			break;
		case PLD_CLK_IN_USE:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_STATUS + 1;
			*mask = MASK_PLD_CLK_IN_USE;
			break;
		case CVP_MODE:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_MODE_CTRL;
			*mask = MASK_CVP_MODE;
			break;
		case HIP_CLK_SEL:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_MODE_CTRL;
			*mask = MASK_HIP_CLK_SEL;
			break;
		case CVP_CONFIG:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_PROG_CTRL;
			*mask = MASK_CVP_CONFIG;
			break;
		case START_XFER:
			*byte_offset = OFFSET_VSEC + OFFSET_CVP_PROG_CTRL;
			*mask = MASK_START_XFER;
			break;
		case CVP_CFG_ERR_LATCH:
			*byte_offset = OFFSET_VSEC + OFFSET_UNC_IE_STATUS;
			*mask = MASK_CVP_CFG_ERR_LATCH;
			break;
		default:
			return -EINVAL;
	}
	return 0;
}

static int altera_cvp_read_bit(int bit, u8 *value)
{
	int byte_offset;
	u8 byte_val, byte_mask;
	if (altera_cvp_get_offset_and_mask(bit, &byte_offset, &byte_mask))
		return -EINVAL;
	if (pci_read_config_byte(cvp_dev.pci_dev, byte_offset, &byte_val))
		return -EAGAIN;
	*value = (byte_val & byte_mask) ? 1 : 0;
	return 0;
}

static int altera_cvp_write_bit(int bit, u8 value)
{
	int byte_offset;
	u8 byte_val, byte_mask;

	switch (bit) {
		case CVP_MODE:
		case HIP_CLK_SEL:
		case CVP_CONFIG:
		case START_XFER:
		case CVP_CFG_ERR_LATCH:
			altera_cvp_get_offset_and_mask(bit, &byte_offset, &byte_mask);
			pci_read_config_byte(cvp_dev.pci_dev, byte_offset, &byte_val);
			byte_val = value ? (byte_val | byte_mask) : (byte_val & ~byte_mask);
			pci_write_config_byte(cvp_dev.pci_dev, byte_offset, byte_val);
			return 0;
		default:
			return -EINVAL; /* only the bits above are writeable */
	}
} 

static int altera_cvp_set_num_clks(int num_clks)
{
	if (num_clks < 1 || num_clks > 64)
		return -EINVAL;
	if (num_clks == 64)
		num_clks = 0x00;
	return (pci_write_config_byte(cvp_dev.pci_dev,
					OFFSET_VSEC+OFFSET_CVP_NUMCLKS,
					num_clks));
}

#define NUM_REG_WRITES 244
#define DUMMY_VALUE 0x00000000
/*
 * altera_cvp_switch_clk() - switch between CvP clock and internal clock
 *
 * Issues dummy memory writes to the PCIe HIP, allowing the Control Block to
 * switch between the HIP's CvP clock and the internal clock.
 */
static int altera_cvp_switch_clk(void)
{
	int i;
	altera_cvp_set_num_clks(1);
	for (i = 0; i < NUM_REG_WRITES; i++) {
		iowrite32(DUMMY_VALUE, cvp_dev.wr_addr);
	}
	return 0;
}

static int altera_cvp_set_data_type(void)
{
	int error, num_clks;
	u8 compr, encr;

	if ((error = altera_cvp_read_bit(DATA_COMPRESSED, &compr)) ||
	    (error = altera_cvp_read_bit(DATA_ENCRYPTED, &encr)))
		return error;

	if (compr)
		num_clks = 8;
	else if (encr)
		num_clks = 4;
	else
		num_clks = 1;

	return (altera_cvp_set_num_clks(num_clks));
}

static int altera_cvp_send_data(u32 *data, unsigned long num_words)
{
#ifdef DEBUG
	u8 bit_val;
	unsigned int i;
	for (i = 0; i < num_words; i++) {
		iowrite32(data[i], cvp_dev.wr_addr);
		if (i + 1 % ERR_CHK_INTERVAL == 0) {
			altera_cvp_read_bit(CVP_CONFIG_ERROR, &bit_val);
			if (bit_val) {
				dev_err(&cvp_dev.pci_dev->dev, "CB detected a CRC error "
								"between words %d and %d\n",
								i + 1 - ERR_CHK_INTERVAL,
								i + 1);
				return -EAGAIN;
			}
		}
	}
	dev_info(&cvp_dev.pci_dev->dev, "A total of %ld 32-bit words were "
					"sent to the FPGA\n", num_words);
#else
	iowrite32_rep(cvp_dev.wr_addr, data, num_words);
#endif /* DEBUG */
	return 0;
}

/* Polls the requested bit until it has the specified value (or until timeout) */
/* Returns 0 once the bit has that value, error code on timeout */
static int altera_cvp_wait_for_bit(int bit, u8 value, u32 n_us)
{
	int rc = 0;
	u8 bit_val;
	u32 n_wait_loops = (n_us > (US_PER_JIFFY * MIN_WAIT)) ?
		(n_us + (US_PER_JIFFY * MIN_WAIT) - 1) / (US_PER_JIFFY * MIN_WAIT) : 1;

	DECLARE_WAIT_QUEUE_HEAD(cvp_wq);

	altera_cvp_read_bit(bit, &bit_val);

	while ((bit_val != value) && (n_wait_loops != 0)) {
		wait_event_timeout(cvp_wq, 0, MIN_WAIT);
		altera_cvp_read_bit(bit, &bit_val);
		--n_wait_loops;
	}

	if (bit_val != value) {
		dev_info(&cvp_dev.pci_dev->dev, "Timed out while polling bit %d\n", bit);
		rc = -EAGAIN;
	}

	return rc;
}

static int altera_cvp_setup(void)
{
	altera_cvp_write_bit(HIP_CLK_SEL, 1);
	altera_cvp_write_bit(CVP_MODE, 1);
	altera_cvp_switch_clk(); /* allow CB to sense if system reset is issued */
	altera_cvp_write_bit(CVP_CONFIG, 1); /* request CB to begin CvP transfer */

	if (altera_cvp_wait_for_bit(CVP_CONFIG_READY, 1, 0))  // wait until CB ready
		return -EAGAIN;

	altera_cvp_switch_clk();
	altera_cvp_write_bit(START_XFER, 1);
	altera_cvp_set_data_type();
	dev_info(&cvp_dev.pci_dev->dev, "Now starting CvP...\n");
	return 0; /* success */
}

static int altera_cvp_teardown(void)
{
	u8 bit_val;

	/* if necessary, flush remainder buffer */
	if (cvp_dev.remain_size > 0) {
		u32 last_word = 0;
		memcpy(&last_word, cvp_dev.remain, cvp_dev.remain_size);
		altera_cvp_send_data(&last_word, cvp_dev.remain_size);
	}

	altera_cvp_write_bit(START_XFER, 0);
	altera_cvp_write_bit(CVP_CONFIG, 0); /* request CB to end CvP transfer */
	altera_cvp_switch_clk();

	if (altera_cvp_wait_for_bit(CVP_CONFIG_READY, 0, 0)) /* wait until CB is ready */
		return -EAGAIN;

	altera_cvp_read_bit(CVP_CFG_ERR_LATCH, &bit_val);
	if (bit_val) {
		dev_err(&cvp_dev.pci_dev->dev, "Configuration error detected, "
						"CvP has failed\n");
		altera_cvp_write_bit(CVP_CFG_ERR_LATCH, 1); /* clear error bit */
	}

	altera_cvp_write_bit(CVP_MODE, 0);
	altera_cvp_write_bit(HIP_CLK_SEL, 0);

	if (!bit_val) { /* wait for application layer to be ready */
		altera_cvp_wait_for_bit(PLD_CLK_IN_USE, 1, 350000);
		altera_cvp_wait_for_bit(USER_MODE, 1, 350000);
		dev_info(&cvp_dev.pci_dev->dev, "CvP successful, application "
						"layer now ready\n");
	}
	return 0; /* success */
}

/* Open and close */

int altera_cvp_open(struct inode *inode, struct file *filp)
{
  const char *fname = NULL;
  fname = filp->f_path.dentry->d_iname;
  if (!strcmp(fname, "ovc_imu")) {
    void *pio_bar = cvp_dev.bar2_addr;
    {
      unsigned long flags;
      u32 pio_prev_value;
      spin_lock_irqsave(&pio_spinlock, flags);
      pio_prev_value = ioread32(pio_bar);
      iowrite32(pio_prev_value | 0x4000, pio_bar);
      iowrite32(pio_prev_value, pio_bar);
      spin_unlock_irqrestore(&pio_spinlock, flags);
    }
    return 0;  // it's fine to open the IMU placeholder simultaneously...
  }

	/* enforce single-open */
	if (!atomic_dec_and_test(&cvp_dev.is_available)) {
		atomic_inc(&cvp_dev.is_available);
		return -EBUSY;
	}

  //dev_info(&cvp_dev.pci_dev->dev, "altera_cvp_open: [%s]\n", fname);

  //char path_buf[256] = {0};
  //dentry_path_raw(filp->f_path.dentry, path_buf, sizeof(path_buf));
  //dev_info(&cvp_dev.pci_dev->dev, "altera_cvp_open filename: [%s]\n", filp->f_path.dentry->d_iname);
  /*
  dev_info(&cvp_dev.pci_dev->dev, "altera_cvp_open: inode=0x%08x, filp=0x%08x\n",
    (unsigned)inode, (unsigned)filp);
  */

  if (!strcmp(filp->f_path.dentry->d_iname, "ovc_cvp")) {
    // we're opening the ovc_cvp driver node
    if ((filp->f_flags & O_ACCMODE) != O_RDONLY) {
      u8 cvp_enabled = 0;
      if (altera_cvp_read_bit(CVP_EN, &cvp_enabled))
        return -EAGAIN;

      if (cvp_enabled)
        return altera_cvp_setup();

      dev_err(&cvp_dev.pci_dev->dev, "CvP not enabled in this FPGA design\n");
      return -EOPNOTSUPP;
    }
    return 0;
  }

	return 0; /* success */
}

int altera_cvp_release(struct inode *inode, struct file *filp)
{
  const char *fname = NULL;
  fname = filp->f_path.dentry->d_iname;

  if (!strcmp(fname, "ovc_imu"))
    return 0;  // don't refcount the IMU pseudo-device. TODO: not this...

	atomic_inc(&cvp_dev.is_available); /* release the device */

  //dev_info(&cvp_dev.pci_dev->dev, "altera_cvp_release: [%s]\n", fname);
	if (!strcmp(fname, "ovc_cvp")) {
    if ((filp->f_flags & O_ACCMODE) != O_RDONLY) {
      return altera_cvp_teardown();
    }
	}
	return 0; /* success */
}

/* Read and write */

ssize_t altera_cvp_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
{
  const char *fname = filp->f_path.dentry->d_iname;
  //dev_info(&cvp_dev.pci_dev->dev, "altera_cvp_write: [%s]\n", fname);
  if (!strcmp(fname, "ovc")) {
    // wait up to 2 seconds
    if (!wait_for_completion_timeout(&image_dma_done, 2 * HZ))
      return -ETIMEDOUT;
    dma_sync_single_for_cpu(
        &cvp_dev.pci_dev->dev,
        cvp_dev.dma_handle,
        OVC_IOCTL_DMA_BUF_SIZE,  // pixels + 256k misc data
        DMA_FROM_DEVICE);
    //t_dma_stop = ktime_get();
    //u64 elapsed_ns;
    //elapsed_ns = ktime_to_ns(ktime_sub(t_dma_stop, t_dma_start));
    //printk("ovc_irq_handler() after %lld ns\n", elapsed_ns);
    return 0;  // success
  }
  else if (!strcmp(fname, "ovc_imu")) {
    // wait up to 1 second
    reinit_completion(&imu_done);
    if (!wait_for_completion_timeout(&imu_done, 1 * HZ))
      return -ETIMEDOUT;
    return 0;  // success
  }
  else if (!strcmp(fname, "ovc_cvp")) {
    int dev_size = NUM_VSEC_REGS * BYTES_IN_REG;
    int i, byte_offset;
    u8 *out_buf;
    ssize_t ret_val; /* number of bytes successfully read */

    if (*f_pos >= dev_size)
      return 0; /* we're at EOF already */
    if (*f_pos + count > dev_size)
      count = dev_size - *f_pos; /* we can only read until EOF */

    out_buf = kmalloc(count, GFP_KERNEL);

    for (i = 0; i < count; i++) {
      byte_offset = OFFSET_VSEC + *f_pos + i;
      pci_read_config_byte(cvp_dev.pci_dev, byte_offset, &out_buf[i]);
    }

    if (copy_to_user(buf, out_buf, count)) {
      ret_val = -EFAULT;
    } else {
      *f_pos += count;
      ret_val = count;
    }

    kfree(out_buf);
    return ret_val;
  }
  else
    return -EIO;
}

ssize_t altera_cvp_write(struct file * filp, const char __user *buf, size_t count, loff_t *f_pos)
{
	ssize_t ret_val; /* number of bytes successfully transferred */
	u8 *send_buf;
	size_t send_buf_size;

  //const char *fname = filp->f_path.dentry->d_iname;
  //dev_info(&cvp_dev.pci_dev->dev, "altera_cvp_write: [%s]\n", fname);
#if 0
  if (!strcmp(fname, "ovc")) {
    unsigned command, offset, value;
    int n;
    dev_info(&cvp_dev.pci_dev->dev, "pio write %d bytes\n", (int)count);
    n = sscanf(buf, "%x %x %x", &command, &offset, &value);
    if (n != 3) {
      dev_info(&cvp_dev.pci_dev->dev,
        "woah! expected 3 hex numbers: CMD, OFFSET, VAL\n");
      return count;  // success or whatever
    }
    /*
    char *endp = NULL;
    int i = simple_strtol(buf, &endp, 10);
    */
    if (command == 1) {
      dev_info(&cvp_dev.pci_dev->dev, "writing 0x%x to BAR2 offset 0x%x", value, offset);
      iowrite32(value, cvp_dev.bar2_addr + offset);
    }
    else if (command == 0) {
      unsigned rd_val;
      dev_info(&cvp_dev.pci_dev->dev, "reading from BAR2 offset 0x%x", offset);
      rd_val = ioread32(cvp_dev.bar2_addr + offset);
      dev_info(&cvp_dev.pci_dev->dev, "read value: 0x%x\n", rd_val);
    }
    return count;  // success
  }
#endif

	send_buf_size = count + cvp_dev.remain_size;
	send_buf = kmalloc(send_buf_size, GFP_KERNEL);

	if (cvp_dev.remain_size > 0)
		memcpy(send_buf, cvp_dev.remain, cvp_dev.remain_size);

	if (copy_from_user(send_buf + cvp_dev.remain_size, buf, count)) {
		ret_val = -EFAULT;
		goto exit;
	}

	/* calculate new remainder */
	cvp_dev.remain_size = send_buf_size % 4;

	/* save bytes in new remainder in cvp_dev */
	if (cvp_dev.remain_size > 0)
		memcpy(cvp_dev.remain,
			send_buf + (send_buf_size - cvp_dev.remain_size),
			cvp_dev.remain_size);

	if (altera_cvp_send_data((u32 *)send_buf, send_buf_size / 4)) {
		ret_val = -EAGAIN;
		goto exit;
	}

	*f_pos += count;
	ret_val = count;
exit:
	kfree (send_buf);
	return ret_val;
}

static bool ovc_imu_txrx(const u32 *txd, const u32 ntx, u32 *rxd, bool hold)
{
  u32 i, j, spi_sr;
  if (ntx == 0) {
    pr_err("ovc: ntx of zero sent to ovc_imu_txrx\n");
    return false;  // buh bye
  }

  for (i = 0; i < ntx; i++) {
    iowrite32(txd[i], cvp_dev.bar3_addr + 4);  // set txd payload
    iowrite32(0x7, cvp_dev.bar3_addr);  // host_req + hold_cs + start

    // spin until SPI done bit is set
    // might have to wait a while if the SPI machinery is busy auto-polling.
    for (j = 0; j < 10000; j++) {
      spi_sr = ioread32(cvp_dev.bar3_addr + 12);
      if (spi_sr & 0x2)
        break;
      udelay(1);
    }
    if (!(spi_sr & 0x2)) {
      pr_err("ovc: ovc_imu_txrx(%d, %s) failed to see done bit :(\n",
        (int)ntx, hold ? "hold" : "no hold");
      return false;  // bad news. didn't ever see the busy bit.
    }
    if (rxd)
      rxd[i] = ioread32(cvp_dev.bar3_addr + 8);

    if (i < ntx-1)
      iowrite32(0x6, cvp_dev.bar3_addr);  // de-assert START
  }

  if (hold)
    iowrite32(0x4, cvp_dev.bar3_addr);  // keep HOST_REQ, nothing else
  else
    iowrite32(0x0, cvp_dev.bar3_addr);  // release SPI control

  return true;
}

static long ovc_ioctl(struct file *f, unsigned int ioctl_num, unsigned long ioctl_param)
{
  switch (ioctl_num) {
    case OVC_IOCTL_SPI_XFER:
    {
      struct ovc_ioctl_spi_xfer spi_xfer; 
      u32 spi_ctrl, spi_txd, spi_rxd, start_mask;
      int i;

      if (copy_from_user(&spi_xfer, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes

      if (spi_xfer.bus != 0 && spi_xfer.bus != 1) {
        printk("ovc: unknown SPI bus ID: %d\n", (int)spi_xfer.bus);
        return -EINVAL;
      }
      //ktime_t start, stop;
      //u64 elapsed_ns;
      //start = ktime_get();
      if (spi_xfer.bus == 0) {
        spi_ctrl = 0 << 29;  // select bus #0
        start_mask = 0x40000000;
      }
      else {
        spi_ctrl = 1 << 29;  // select bus #1
        start_mask = 0x80000000;
      }

      spi_txd = spi_xfer.reg_addr << 17;
      if (spi_xfer.dir == OVC_IOCTL_SPI_XFER_DIR_WRITE)
        spi_txd |= (1 << 16) | spi_xfer.reg_val;

      iowrite32(spi_ctrl, cvp_dev.bar4_addr + 7*4);  // select bus 0 or 1
      iowrite32(spi_txd, cvp_dev.bar4_addr + 8*4);  // register 8 = spi txd
      iowrite32(spi_ctrl | start_mask, cvp_dev.bar4_addr + 7*4);  // start tx/rx
      udelay(5);  // just spin for a bit to let it get started
      iowrite32(spi_ctrl, cvp_dev.bar4_addr + 7*4);  // un-set start bit

      for (i = 0; i < 100; i++) {
        spi_rxd = ioread32(cvp_dev.bar4_addr + 9*4);  // spi status register
        if (spi_rxd & 0x80000000)
          break;
        udelay(5);  // just spin for a bit. it will be done soon (20-50 us)
      }
      spi_xfer.reg_val = spi_rxd & 0xffff;
      //stop = ktime_get();
      //elapsed_ns = ktime_to_ns(ktime_sub(stop, start));
      //printk("ovc: rx 0x%04x   i = %d  ns: %lld\n",
      //  (unsigned)spi_xfer.reg_val, i); //, elapsed_ns);
      if (copy_to_user((void *)ioctl_param, &spi_xfer, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return 0;
    }
    case OVC_IOCTL_PIO_SET:
    {
      struct ovc_pio_set pio_set;
      u32 pio_prev_value;
      if (copy_from_user(&pio_set, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      {
        unsigned long flags;
        spin_lock_irqsave(&pio_spinlock, flags);
        pio_prev_value = ioread32(cvp_dev.bar2_addr + 0);
        if (pio_set.pio_state)
          pio_prev_value |= (1 << pio_set.pio_idx);
        else
          pio_prev_value &= ~(1 << pio_set.pio_idx);
        iowrite32(pio_prev_value, cvp_dev.bar2_addr + 0);
        spin_unlock_irqrestore(&pio_spinlock, flags);
      }
      return 0;
    }
    case OVC_IOCTL_BITSLIP:
    {
      struct ovc_ioctl_bitslip bs;
      if (copy_from_user(&bs, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      iowrite32(0, cvp_dev.bar4_addr + 3*4);
      iowrite32(bs.channels, cvp_dev.bar4_addr + 3*4);
      iowrite32(0, cvp_dev.bar4_addr + 3*4);
      return 0;
    }
    case OVC_IOCTL_READ_DATA:
    {
      struct ovc_ioctl_read_data read_data;
      if (copy_from_user(&read_data,
                         (void *)ioctl_param,
                         _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      iowrite32(read_data.channel, cvp_dev.bar4_addr + 4*4);
      read_data.data = ioread32(cvp_dev.bar2_addr + 0x10);
      // read twice to make sure we've waited long enough for our
      // new channel selection to be latched
      read_data.data = ioread32(cvp_dev.bar2_addr + 0x10);
      if (copy_to_user((void *)ioctl_param, &read_data, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return 0;
    }
    case OVC_IOCTL_DMA_START:
    {
      struct ovc_ioctl_dma_start dma_start; 
      u32 pio_prev_value;
      //int i;
      void *pio_bar = cvp_dev.bar2_addr;
      //void *pio_in_bar = cvp_dev.bar2_addr + 0x10;
      //void *pio_reg_val_bar = cvp_dev.bar2_addr + 0x60;

      if (copy_from_user(&dma_start, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      dma_start.len &= 0xffff;  // clamp to 16-bit
      // write lower 32 bits of physical address
      if (cvp_dev.dma_handle & 0xffffffff00000000) {
        // address is beyond 32-bit space; use 64-bit PCIe addressing
        iowrite32((uint32_t)cvp_dev.dma_handle | 0x1,
          cvp_dev.wr_addr + 0x1000);
        // write upper 32 bits of physical address
        iowrite32((uint32_t)(cvp_dev.dma_handle >> 32),
          cvp_dev.wr_addr + 0x1004);
      }
      else {
        // address fits within 32 bits, so we have to use 32-bit PCIe addr mode
        iowrite32((uint32_t)cvp_dev.dma_handle, cvp_dev.wr_addr + 0x1000);
        // write upper 32 bits of physical address
        iowrite32(0, cvp_dev.wr_addr + 0x1004);
      }

      /*
      printk("starting dma transfer of length %d to offset %08x\n",
        dma_start.len, (unsigned)dma_start.offset);
      */

      /*
      printk("base addr translation: 0x%08x_0x%08x\n",
        (unsigned)ioread32(cvp_dev.wr_addr + 0x1004),
        (unsigned)ioread32(cvp_dev.wr_addr + 0x1000));
      */

      // set dma address offset register
      iowrite32(dma_start.offset, cvp_dev.bar4_addr + 2*4);

      // kick off the FPGA data transfer machinery by toggling start bit
      {
        unsigned long flags;
        spin_lock_irqsave(&pio_spinlock, flags);
        pio_prev_value = ioread32(pio_bar);
        iowrite32(pio_prev_value | 0x0100, pio_bar);  // assert start bit
        iowrite32(pio_prev_value, pio_bar);  // de-assert start bit
        spin_unlock_irqrestore(&pio_spinlock, flags);
      }

      t_dma_start = ktime_get();

      reinit_completion(&image_dma_done);
#if 0
      for (i = 0; i < 10; i++) {
        // udelay(1);  // just spin for a bit. it will be done soon
        //printk("fabric status: 0x%08x  dma status: 0x%08x\n",
        //  (unsigned)ioread32(pio_in_bar), (unsigned)ioread32(dma_csr));
        //printk("ovc status: 0x%08x\n", (unsigned)ioread32(pio_in_bar));
      }
#endif

      /*
      dma_sync_single_for_cpu(
        &cvp_dev.pci_dev->dev,
        cvp_dev.dma_handle,
        OVC_DMA_BUF_SIZE,
        DMA_FROM_DEVICE);
      */

      /*
      print_hex_dump(KERN_DEBUG, "dma_buf: ", DUMP_PREFIX_ADDRESS, 
        16, 4, cvp_dev.dma_buf, 128 * dma_start.len + 512, 0);
      */

      return 0;
    }
    case OVC_IOCTL_IMU_TXRX:
    {
      struct ovc_ioctl_imu_txrx imu_txrx;
      int i;
      //u32 spi_sr, rxd, txd;
      #define MAX_TXRX (OVC_IOCTL_IMU_TXRX_BUF_LEN+1)
      u32 txd[MAX_TXRX], rxd[MAX_TXRX];

      if (copy_from_user(&imu_txrx, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes

      if (imu_txrx.dir != OVC_IOCTL_IMU_TXRX_DIR_READ &&
          imu_txrx.dir != OVC_IOCTL_IMU_TXRX_DIR_WRITE) {
        pr_err("ovc: unknown IMU txrx direction: %d\n", (int)imu_txrx.dir);
        return -EINVAL;
      }

      if (imu_txrx.len >= OVC_IOCTL_IMU_TXRX_BUF_LEN ||
          imu_txrx.len % 4 != 0) {
        pr_err("ovc: invalid IMU txrx length: %d\n", (int)imu_txrx.len);
      }

      //printk("ovc imu txrx: dir %d reg %d len %d\n",
      //  (int)imu_txrx.dir, (int)imu_txrx.reg_idx, (int)imu_txrx.len);

      txd[0] = imu_txrx.reg_idx << 16;
      if (imu_txrx.dir == OVC_IOCTL_IMU_TXRX_DIR_READ) {
        txd[0] |= (0x01 << 24);  // command: register read
        // send the read-request header (32 bits)
        if (!ovc_imu_txrx(txd, 1, NULL, true)) {
          pr_err("ovc_imu_txrx: error during imu reg read header txrx\n");
          return -EIO;
        }
      }
      else if (imu_txrx.dir == OVC_IOCTL_IMU_TXRX_DIR_WRITE) {
        txd[0] |= (0x02 << 24);  // command: register write
        for (i = 0; i < imu_txrx.len/4; i++) {
          // byteswap: little->big endian
          txd[i+1] = (imu_txrx.buf[i*4 + 0] << 24) |
                     (imu_txrx.buf[i*4 + 1] << 16) |
                     (imu_txrx.buf[i*4 + 2] <<  8) |
                     (imu_txrx.buf[i*4 + 3] <<  0);
        }
        if (!ovc_imu_txrx(txd, imu_txrx.len/4 + 1, NULL, true)) {
          pr_err("ovc_imu_txrx: error during reg write header txrx\n");
          return -EIO;
        }
      }

      udelay(100);  // insert some delay according to VN-100 datasheet

      // zero out the tx buffer
      for (i = 0; i < imu_txrx.len/4 + 1; i++)
        txd[i] = 0;

      if (imu_txrx.dir == OVC_IOCTL_IMU_TXRX_DIR_READ) {
        if (!ovc_imu_txrx(txd, imu_txrx.len/4 + 1, rxd, false)) {
          pr_err("ovc: error during imu read response txrx\n");
          return -EIO;
        }
        // byteswap the rx buffer
        for (i = 0; i < imu_txrx.len/4; i++) {
          imu_txrx.buf[i*4 + 0] = (rxd[i+1] >> 24) & 0xff;
          imu_txrx.buf[i*4 + 1] = (rxd[i+1] >> 16) & 0xff;
          imu_txrx.buf[i*4 + 2] = (rxd[i+1] >>  8) & 0xff;
          imu_txrx.buf[i*4 + 3] = (rxd[i+1] >>  0) & 0xff;
        }
      }
      else if (imu_txrx.dir == OVC_IOCTL_IMU_TXRX_DIR_WRITE) {
        if (!ovc_imu_txrx(txd, 1, rxd, false)) {
          pr_err("ovc: error during imu write response txrx\n");
          return -EIO;
        }
        // todo: check response header for errors during writes
      }

      /*
      print_hex_dump(KERN_DEBUG, "imu_txrx_buf: ", DUMP_PREFIX_ADDRESS, 
        4, 4, imu_txrx.buf, 60, 0);
      for (i = 0; i < 32; i++) {
        printk("buf[%d] = 0x%02x\n", i, (int)imu_txrx.buf[i]);
      }
      */

      if (copy_to_user((void *)ioctl_param, &imu_txrx, _IOC_SIZE(ioctl_num)))
        return -EACCES;

      udelay(100);

      return 0;
    }
    case OVC_IOCTL_IMU_SET_MODE:
    {
      struct ovc_ioctl_imu_set_mode imu_set_mode;

      if (copy_from_user(&imu_set_mode, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes

      if (imu_set_mode.mode == OVC_IOCTL_IMU_SET_MODE_IDLE)
        iowrite32(0x0, cvp_dev.bar3_addr);  // turn off auto-poll bit
      else if (imu_set_mode.mode == OVC_IOCTL_IMU_SET_MODE_AUTO)
        iowrite32(0x01000000, cvp_dev.bar3_addr);  // set auto-poll bit
      else {
        printk("ovc: unknown IMU mode requested: %d\n", (int)imu_set_mode.mode);
        return -EINVAL;
      }
      return 0;
    }
    case OVC_IOCTL_IMU_READ:
    {
      int i;
      struct ovc_ioctl_imu_read imu_data;
      uint8_t bytes[4];
      if (copy_from_user(&imu_data, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes

      // first copy in the timestamp
      imu_data.t_usecs =
        ((uint64_t)ioread32(cvp_dev.bar3_addr + 16 + 0) << 32) |
         (uint64_t)ioread32(cvp_dev.bar3_addr + 16 + 4);

      // now byteswap the inbound IMU register data since it's big-endian
      // todo: move this to the FPGA hardware, it's trivial there...
      for (i = 2; i < sizeof(imu_data)/4; i++) {
        *((uint32_t *)bytes) = ioread32(cvp_dev.bar3_addr + 16 + i*4);
        //*(((uint32_t *)&imu_data)+i) =
        *(((uint8_t *)(&imu_data)) + i*4 + 0) = bytes[3];
        *(((uint8_t *)(&imu_data)) + i*4 + 1) = bytes[2];
        *(((uint8_t *)(&imu_data)) + i*4 + 2) = bytes[1];
        *(((uint8_t *)(&imu_data)) + i*4 + 3) = bytes[0];
      }

      if (copy_to_user((void *)ioctl_param, &imu_data, _IOC_SIZE(ioctl_num)))
        return -EACCES;

      return 0;
    }
    case OVC_IOCTL_ENABLE_REG_RAM:
    {
      struct ovc_ioctl_enable_reg_ram cmd;
      if (copy_from_user(&cmd, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      if (cmd.enable) {
        printk("enabling OVC register ram\n");
        iowrite32(1, cvp_dev.bar4_addr);  // bit 0 = enable
      }
      else {
        //printk("disabling OVC register ram\n");
        iowrite32(0, cvp_dev.bar4_addr);  // bit 0 = enable
      }
      return 0;
    }
    case OVC_IOCTL_SET_SYNC_TIMING:
    {
      struct ovc_ioctl_set_sync_timing timing;
      if (copy_from_user(&timing, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      iowrite32((u32)timing.imu_decimation, cvp_dev.bar4_addr + 6*4);
      return 0;
    }
    case OVC_IOCTL_SET_EXPOSURE:
    {
      struct ovc_ioctl_set_exposure exposure;
      if (copy_from_user(&exposure, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // oh noes
      iowrite32(exposure.exposure_usec, cvp_dev.bar4_addr + 5*4);
      return 0;
    }
    case OVC_IOCTL_SET_AST_PARAMS:
    {
      struct ovc_ioctl_set_ast_params ast;
      u32 threshold_u32;
      if (copy_from_user(&ast, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      threshold_u32 = (u32)ast.threshold;
      iowrite32(threshold_u32, cvp_dev.bar4_addr + 10*4);
      printk("set ast threshold to %d\n", threshold_u32);
      return 0;
    }
    default:
      printk("ovc: unrecognized ioctl command\n");
      return -EINVAL;
  }
}

static int ovc_mmap(struct file *f, struct vm_area_struct *vma)
{
  if (remap_pfn_range(vma, vma->vm_start,
      virt_to_phys(cvp_dev.dma_buf) >> PAGE_SHIFT,
      vma->vm_end - vma->vm_start,
      vma->vm_page_prot)) {
    printk("ovc: oh noes, remap_pfn_range() failed\n");
    return -EAGAIN;
  }
  printk("ovc: remap_pfn_range() successful\n");
  return 0;
}

struct file_operations altera_cvp_fops = {
	.owner =   THIS_MODULE,
	.llseek =  no_llseek,
	.read =    altera_cvp_read,
	.write =   altera_cvp_write,
	.open =    altera_cvp_open,
	.release = altera_cvp_release,
  .unlocked_ioctl = ovc_ioctl,
  .mmap = ovc_mmap,
};

static irqreturn_t ovc_irq_handler(int irq, void *dev_id)
{
  uint32_t pio_prev_value;
  void *pio_bar = cvp_dev.bar2_addr;
  u32 interrupt_status;
  u32 nspin;

  nspin = 0;
  interrupt_status = ioread32(cvp_dev.wr_addr + 0x40);
  while (interrupt_status & 0x3) {
    nspin++;
    if (interrupt_status & 0x1) {
      // avalon-mm irq 0 = image DMA complete
      {
        // de-assert the image-done interrupt flag
        unsigned long flags;
        spin_lock_irqsave(&pio_spinlock, flags);
        pio_prev_value = ioread32(pio_bar);
        iowrite32(pio_prev_value | 0x2000, pio_bar);
        iowrite32(pio_prev_value, pio_bar);
        spin_unlock_irqrestore(&pio_spinlock, flags);
      }
      complete(&image_dma_done);
      // because all this takes time, we need to re-read IRQ status
      // in case the other interrupt was signaled
      interrupt_status = ioread32(cvp_dev.wr_addr + 0x40);
    }

    if (interrupt_status & 0x2) {
      // avalon-mm irq 1 = imu_interrupt
      {
        // de-assert the imu-done interrupt flag
        unsigned long flags;
        spin_lock_irqsave(&pio_spinlock, flags);
        pio_prev_value = ioread32(pio_bar);
        iowrite32(pio_prev_value | 0x4000, pio_bar);
        iowrite32(pio_prev_value, pio_bar);
        spin_unlock_irqrestore(&pio_spinlock, flags);
      }
      complete(&imu_done);
      // because all this takes time, we need to re-read IRQ status
      // in case the other interrupt was signaled
      interrupt_status = ioread32(cvp_dev.wr_addr + 0x40);
    }
  }
  if (nspin > 2) {
    //printk(
		printk(KERN_ERR "ovc: nspin = %d\n", nspin);
  }
  return IRQ_HANDLED;
}

static int altera_cvp_probe(struct pci_dev *dev, const struct pci_device_id *id)
{
	int rc = 0;  

	if((dev->vendor == vid) && (dev->device == did)) {
		rc = pci_enable_device(dev);
		if (rc) {
			dev_err(&dev->dev, "pci_enable device() failed\n");
			return rc;
		}
		dev_info(&dev->dev, "Found and enabled PCI device with "
					"VID 0x%04X, DID 0x%04X\n", vid, did);

		rc = pci_request_regions(dev, "ovc");
		if (rc) {
			dev_err(&dev->dev, "pci_request_regions() failed\n");
			return rc;
		}

    pci_set_master(dev);
    //pci_set_mwi(dev);
    pci_set_dma_mask(dev, DMA_BIT_MASK(64));
    pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(64));
    //int nirq = pci_alloc_irq_vectors(dev, 1, 1, PCI_IRQ_MSI);
    //pci_enable_msi_range(dev, 0, 0);
    // cat /proc/interrupts

		cvp_dev.wr_addr = pci_iomap(dev, 0, 0);
    cvp_dev.bar2_addr = pci_iomap(dev, 2, 0);  // BAR 2
    cvp_dev.bar3_addr = pci_iomap(dev, 3, 0);  // BAR 3
    cvp_dev.bar4_addr = pci_iomap(dev, 4, 0);  // BAR 4
    dev_info(&dev->dev, "bar0_addr = 0x%px\n", cvp_dev.wr_addr);
    dev_info(&dev->dev, "bar2_addr = 0x%px\n", cvp_dev.bar2_addr);
    dev_info(&dev->dev, "bar3_addr = 0x%px\n", cvp_dev.bar3_addr);
    dev_info(&dev->dev, "bar4_addr = 0x%px\n", cvp_dev.bar4_addr);

    // allocate DMA buffer memory the coherent way
    //dma_addr_t dma_handle;
    //dma_alloc_coherent(dev->device, 100*4096, &dma_handle, GFP_KERNEL);
    // todo: look into the "new" Linux CMA. Anything special need to happen?

    //DMA_ATTR_WRITE_COMBINE);
    cvp_dev.dma_buf = kmalloc(OVC_DMA_BUF_SIZE, GFP_KERNEL);
    dev_info(&dev->dev, "dma_buf kernel addr = 0x%px\n", cvp_dev.dma_buf);
    
    cvp_dev.dma_handle =
      dma_map_single(&dev->dev, cvp_dev.dma_buf,
                     OVC_DMA_BUF_SIZE, DMA_FROM_DEVICE);

    if (dma_mapping_error(&dev->dev, cvp_dev.dma_handle)) {
      dev_info(&dev->dev, "ahhh dma_mapping_error() !!!\n");
    }
    else {
      dev_info(&dev->dev, "dma_handle: 0x%llx\n", cvp_dev.dma_handle);
    }

		cvp_dev.pci_dev = dev; /* store pointer for PCI API calls */

    init_completion(&image_dma_done);
    init_completion(&imu_done);

    rc = pci_enable_msi_range(dev, 1, 1);
    //dev_info(&dev->dev, "allocated %d IRQ vectors: %d\n", rc, dev->irq);
    // todo: check rc and do something smart if it's not 1
    rc = request_irq(dev->irq, ovc_irq_handler, 0, "ovc", &cvp_dev);
    //dev_info(&dev->dev, "request_irq(0) returned %d\n", rc);
    iowrite32(0x3, cvp_dev.wr_addr + 0x50);  // enable MSI interrupts 0 and 1
    //iowrite32(0x1, cvp_dev.wr_addr + 0x50);  // enable MSI interrupt 0
		return 0;
	} else {
		dev_err(&dev->dev, "ovc probe: this PCI device does not match "
					"VID 0x%04X, DID 0x%04X\n", vid, did);
		return -ENODEV;
	}
}

static void altera_cvp_remove(struct pci_dev *dev)
{
  iowrite32(0, cvp_dev.wr_addr + 0x50);  // disable all MSI interrupts
  msleep(100);  // wait for long enough to guarantee that we're pretty sure
                // that all DMA is done. TODO: something smarter than this.
  //pci_free_irq_vectors(dev);
  if (dev->irq > 0) {
    free_irq(dev->irq, &cvp_dev);
  }
  pci_disable_msi(dev);

  dma_unmap_single(&dev->dev, cvp_dev.dma_handle,
    OVC_DMA_BUF_SIZE, DMA_FROM_DEVICE);
  kfree(cvp_dev.dma_buf);

	pci_iounmap(dev, cvp_dev.wr_addr);
	pci_iounmap(dev, cvp_dev.bar2_addr);
	pci_iounmap(dev, cvp_dev.bar3_addr);
	pci_iounmap(dev, cvp_dev.bar4_addr);

	pci_disable_device(dev);
	pci_release_regions(dev);
}

/* PCIe HIP on FPGA can have any combination of IDs based on design settings */
static struct pci_device_id pci_ids[] = {
	{ PCI_DEVICE(PCI_ANY_ID, PCI_ANY_ID), },
	{ 0, }
};
MODULE_DEVICE_TABLE(pci, pci_ids);

static struct pci_driver cvp_driver = {
	.name = "ovc",
	.id_table = pci_ids,
	.probe = altera_cvp_probe,
	.remove = altera_cvp_remove,
};

/* Module functions */

static int __init altera_cvp_init(void)
{
	int rc = 0;
	dev_t dev;

	rc = alloc_chrdev_region(&dev, 0, 1, "ovc");
	if (rc) {
		printk(KERN_ERR "ovc: Allocation of char device numbers failed\n");
		goto exit;
	}

	cvp_dev.dev = dev; /* store major and minor numbers for char device */
	altera_cvp_major = MAJOR(dev);

	rc = pci_register_driver(&cvp_driver);
	if (rc) {
		printk(KERN_ERR "ovc: PCI driver registration failed\n");
		unregister_chrdev_region(MKDEV(altera_cvp_major, 0), 1);
		goto exit;
	}

	cdev_init(&cvp_dev.cdev, &altera_cvp_fops);
	cvp_dev.cdev.owner = THIS_MODULE;
	rc = cdev_add(&cvp_dev.cdev, dev, 1);
	if (rc) {
		printk(KERN_ERR "ovc: Unable to add char device to the system\n");
		pci_unregister_driver(&cvp_driver);
		goto exit;
	}

	cvp_dev.remain_size = 0;

	atomic_set(&cvp_dev.is_available, 1);
exit:
	return rc;
}

static void __exit altera_cvp_exit(void)
{
	cdev_del(&cvp_dev.cdev);
	unregister_chrdev_region(MKDEV(altera_cvp_major, 0), 1);
	pci_unregister_driver(&cvp_driver);
}

module_init(altera_cvp_init);
module_exit(altera_cvp_exit);

MODULE_AUTHOR("Altera Corporation <support@altera.com>");
MODULE_DESCRIPTION("Configuration driver for Altera CvP-capable FPGAs");
MODULE_VERSION("0.0.1");
MODULE_LICENSE("Dual BSD/GPL");

