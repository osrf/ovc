#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/delay.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
//#include <linux/io.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/pci.h>
#include <asm/spinlock.h>
#include <linux/uaccess.h>
#include "ovc2_ioctl.h"
//#include <linux/uaccess.h>

static unsigned short vid = 0x1234;
static unsigned short did = 0x5678;
module_param(vid, ushort, S_IRUGO);
module_param(did, ushort, S_IRUGO);
#define OVC2_CHRDEV_REGION_NAME "ovc2"
#define OVC2_CHRDEV_COUNT 3
#define OVC2_MINOR_CORE 0
#define OVC2_MINOR_IMU  1
#define OVC2_MINOR_CAM  2

#define OVC2_CAM_DMA_BUF_SIZE (4*1024*1024)
struct ovc2_core {
  struct cdev cdev_core, cdev_imu, cdev_cam;
  int major;  // will be populated by alloc_chrdev_region()
  struct pci_dev *pci_dev;
  void __iomem *bar0_addr, *bar2_addr, *bar3_addr;
  atomic_t is_available;
  struct class *dev_class;
  struct device *device;
  struct completion cam_done, imu_done;
  struct ovc2_imu_data imu_data;
  uint8_t *cam_dma_buf;
  dma_addr_t cam_dma_addr;
};
static struct ovc2_core ovc2_core;
//////////////////////////////////////////////////////////////////////
DEFINE_SPINLOCK(pio_spinlock);
//////////////////////////////////////////////////////////////////////

int ovc2_core_open(struct inode *inode, struct file *fp)
{
  //printk(KERN_INFO "ovc2_core_open()\n");
  if (!atomic_dec_and_test(&ovc2_core.is_available)) {
    atomic_inc(&ovc2_core.is_available);
    return -EBUSY;
  }
  return 0;  // success  
}

int ovc2_core_release(struct inode *inode, struct file *file)
{
  //printk(KERN_INFO "ovc2_core_release()\n");
  atomic_inc(&ovc2_core.is_available);
  return 0;  // success
}

static long ovc2_cycle_bit(uint32_t reg_idx, uint8_t bit_idx)
{
  if (reg_idx == OVC2_REG_PCIE_PIO) {
    uint32_t pio_value;
    unsigned long flags;
    spin_lock_irqsave(&pio_spinlock, flags);
    pio_value = ioread32(ovc2_core.bar0_addr + 0x4000);
    iowrite32(pio_value | (1 << bit_idx), ovc2_core.bar0_addr + 0x4000);
    iowrite32(pio_value, ovc2_core.bar0_addr + 0x4000);
    spin_unlock_irqrestore(&pio_spinlock, flags);
  }
  else {
    // print warning message to kernel log? or just ignore?
  }
  return 0;
}

static long ovc2_set_bit(uint32_t reg_idx, uint8_t bit_idx, bool state)
{
  if (reg_idx == OVC2_REG_PCIE_PIO) {
    uint32_t pio_value;
    unsigned long flags;
    spin_lock_irqsave(&pio_spinlock, flags);
    pio_value = ioread32(ovc2_core.bar0_addr + 0x4000);
    if (state)
      pio_value |= (1 << bit_idx);
    else
      pio_value &= ~(1 << bit_idx);
    iowrite32(pio_value, ovc2_core.bar0_addr + 0x4000);
    spin_unlock_irqrestore(&pio_spinlock, flags);
    //printk(KERN_INFO "ovc2_core: pio_value now 0x%08x\n", pio_value);
  }
  else {
    // print warning message to kernel log? or just ignore?
  }
  return 0;
}

/*
static void ovc2_print_regs(void)
{
  u32 reg_idx, reg_val;
  for (reg_idx = 0; reg_idx < 0xb; reg_idx++) {
    reg_val = ioread32(ovc2_core.bar2_addr + 0x4 * reg_idx);
    printk(KERN_INFO "ovc2_core: reg 0x%02x: %08x\n",
      (unsigned)reg_idx, (unsigned)reg_val);
  }
}
*/

static long ovc2_enable_reg_ram(bool enable)
{
  //u32 reg0_val;
	iowrite32(enable ? 1 : 0, ovc2_core.bar2_addr);  // bit 0, offset 0 = enable
  //reg0_val = ioread32(ovc2_core.bar2_addr);
  //printk(KERN_INFO "ovc2_core: reg0 = 0x%08x  enable = %d\n", reg0_val,
  //  enable ? 1 : 0);
  return 0;
}
  //printk(KERN_INFO "ovc2_core: reg1 = 0x%08x\n", ioread32(ovc2_core.bar2_addr + 0x4));

static long ovc2_spi_xfer(u8 bus, u8 dir, u16 reg_addr, u16 reg_val)
{
  int i;
  u32 spi_ctrl, spi_txd, spi_rxd, start_mask;

  //printk(KERN_INFO "ovc2_core: spi_xfer: bus %d, dir %d, reg_addr 0x%04x, reg_val 0x%04x\n", (int)bus, (int)dir, (unsigned)reg_addr, (unsigned)reg_val);

  if (bus != 0 && bus != 1) {
    printk(KERN_ERR "ovc2_core: unknown SPI bus: %d\n", (int)bus);
    return -EINVAL;
  }
  if (bus == 0) {
    spi_ctrl = 0 << 29;  // select bus #0
    start_mask = 0x40000000;
  }
  else {
    spi_ctrl = 1 << 29;  // select bus #1
    start_mask = 0x80000000;
  }
  spi_txd = reg_addr << 17;
  if (dir == OVC2_IOCTL_SPI_XFER_DIR_WRITE)
    spi_txd |= (1 << 16) | reg_val;

  spi_rxd = 0;

  //printk(KERN_INFO "ovc2_core: writing %08x to bar2 addr 7*4\n",
  //  (unsigned)spi_ctrl);

	iowrite32(spi_ctrl, ovc2_core.bar2_addr + 7*4);  // select bus 0 or 1
	iowrite32(spi_txd, ovc2_core.bar2_addr + 8*4);  // register 8 = spi txd
	iowrite32(spi_ctrl | start_mask, ovc2_core.bar2_addr + 7*4);  // start tx/rx
	udelay(5);  // just spin for a bit to let it get started
	iowrite32(spi_ctrl, ovc2_core.bar2_addr + 7*4);  // un-set start bit

  #define OVC2_SPI_XFER_MAX_WAIT_ATTEMPTS 100
	for (i = 0; i < OVC2_SPI_XFER_MAX_WAIT_ATTEMPTS; i++) {
		spi_rxd = ioread32(ovc2_core.bar2_addr + 9*4);  // spi status register
		if (spi_rxd & 0x80000000)
			break;
		udelay(5);  // just spin for a bit. it will be done soon (20-50 us)
	}
  if (i >= OVC2_SPI_XFER_MAX_WAIT_ATTEMPTS) {
    printk(KERN_ERR "ovc2_core: SPI transfer didn't complete :(\n");
    return -EIO;
  }

  return spi_rxd & 0xffff;
}

static u32 ovc2_read_pio(u8 channel)
{
  iowrite32(channel, ovc2_core.bar2_addr + 4*4);
  ioread32(ovc2_core.bar0_addr + 0x4010);
  // read twice to make sure we've waited long enough for our channel
  // selection to be latched and copied through the register chain
  return ioread32(ovc2_core.bar0_addr + 0x4010);
}

static long ovc2_bitslip(u32 channels)
{
  iowrite32(0, ovc2_core.bar2_addr + 3*4);         // make sure it's zero
  iowrite32(channels, ovc2_core.bar2_addr + 3*4);  // set desired bits
  iowrite32(0, ovc2_core.bar2_addr + 3*4);         // set back to zero
  return 0;
}

static long ovc2_imu_set_mode(u32 mode)
{
  if (mode == OVC2_IOCTL_IMU_SET_MODE_IDLE)
    iowrite32(0x0, ovc2_core.bar3_addr);  // clear the auto-poll bit
  else if (mode == OVC2_IOCTL_IMU_SET_MODE_AUTO)
    iowrite32(0x01000000, ovc2_core.bar3_addr);  // set the auto-poll bit
  else {
    printk(KERN_ERR "ovc2_core: unknown IMU mode requested: 0x%08x\n",
      (unsigned)mode);
    return -EINVAL;
  }
  return 0;
}

static long ovc2_cam_set_mode(u32 mode)
{
  if (mode == OVC2_IOCTL_CAM_SET_MODE_IDLE) {
    ovc2_set_bit(OVC2_REG_PCIE_PIO, 8, false);  // clear the dma-enable bit
  }
  else if (mode == OVC2_IOCTL_CAM_SET_MODE_AUTO) {
    if (ovc2_core.cam_dma_addr & 0xffffffff00000000) {
      printk(KERN_INFO "ovc2_core: 64-bit address\n");
      // address is beyond 32-bit space. need to use 64-bit PCIe addressing
      iowrite32((uint32_t)(ovc2_core.cam_dma_addr | 0x1),
          ovc2_core.bar0_addr + 0x1000);
      iowrite32((uint32_t)(ovc2_core.cam_dma_addr >> 32),
          ovc2_core.bar0_addr + 0x1004);
    }
    else {
      printk(KERN_INFO "ovc2_core: 32-bit address\n");
      // address fits within 32 bits, so we have to use 32-bit PCIe addr mode
      iowrite32((uint32_t)ovc2_core.cam_dma_addr,
          ovc2_core.bar0_addr + 0x1000);
      iowrite32(0, ovc2_core.bar0_addr + 0x1004);
    }
    iowrite32(0, ovc2_core.bar2_addr + 2*4);  // dma addr offset 0 for now
    ovc2_set_bit(OVC2_REG_PCIE_PIO, 8, true);  // set the dma-enable bit
  }
  else {
    printk(KERN_ERR "ovc2_core: unknown cam mode requested: 0x%08x\n",
      (unsigned)mode);
    return -EINVAL;
  }
  return 0;
}

static long ovc2_set_sync_timing(uint32_t imu_decimation)
{
  iowrite32(imu_decimation, ovc2_core.bar2_addr + 6*4);
  return 0;
}

static long ovc2_set_exposure(uint32_t exposure_usec)
{
  iowrite32(exposure_usec, ovc2_core.bar2_addr + 5*4);
  return 0;
}

static long ovc2_set_ast_params(uint8_t threshold)
{
  iowrite32((u32)threshold, ovc2_core.bar2_addr + 10*4);
  return 0;
}

//#define OVC2_IRQ_IMU_TIMING

static irqreturn_t ovc2_irq_handler(int irq, void *dev_id)
{
  u32 irq_status, nspin;
#ifdef OVC2_IRQ_IMU_TIMING
  static u64 imu_read_time_sum, irq_count;
#endif
  irq_status = ioread32(ovc2_core.bar0_addr + 0x40);
  for (nspin = 0; irq_status & 0x3; nspin++) {
    if (irq_status & 0x1) {
      // image DMA complete
      ovc2_cycle_bit(OVC2_REG_PCIE_PIO, 13);
      complete(&ovc2_core.cam_done);
      irq_status = ioread32(ovc2_core.bar0_addr + 0x40);
    }
    if (irq_status & 0x2) {
      // clear the imu-done interrupt flag
#ifdef OVC2_IRQ_IMU_TIMING
      static ktime_t t_imu_start, t_imu_stop;
      t_imu_start = ktime_get();
#endif
      ovc2_cycle_bit(OVC2_REG_PCIE_PIO, 14);
      /*
      // seems like we're supposed to use memcpy_fromio here...
      // but we know these addresses will be aligned since the
      // structs start with a 64-bit value, and just plain
      // 'memcpy' is about 3.5x faster... so let's go with it
      memcpy_fromio(&ovc2_core.imu_data,
        ovc2_core.bar3_addr + 16,
        sizeof(struct ovc2_imu_data)/4);
      */
      memcpy(&ovc2_core.imu_data,
        ovc2_core.bar3_addr + 16,
        sizeof(struct ovc2_imu_data));

#ifdef OVC2_IRQ_IMU_TIMING
      t_imu_stop = ktime_get();
      imu_read_time_sum += ktime_to_ns(ktime_sub(t_imu_stop, t_imu_start));
#define SUM_TERMS 200
      if (irq_count++ % SUM_TERMS == 0) {
        u64 t_imu_avg = imu_read_time_sum / SUM_TERMS;
        printk(KERN_INFO "ovc2_core: average t_imu ns: %d\n", (int)t_imu_avg);
        imu_read_time_sum = 0;
      }
#endif
      complete(&ovc2_core.imu_done);
      irq_status = ioread32(ovc2_core.bar0_addr + 0x40);
    }
  }
  if (nspin > 2) {
    printk(KERN_ERR "ovc2_core: nspin = %d\n", nspin);  // only for debugging
  }
  return IRQ_HANDLED;
}

static long ovc2_core_ioctl(
  struct file *file, unsigned int ioctl_num, unsigned long ioctl_param)
{
  int rc;
  switch (ioctl_num)
  {
    case OVC2_IOCTL_SET_BIT:
    {
      struct ovc2_ioctl_set_bit sb;
      if (copy_from_user(&sb, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // uh oh
      return ovc2_set_bit(sb.reg_idx, sb.bit_idx, sb.state ? true : false);
    }
    case OVC2_IOCTL_SPI_XFER:
    {
      struct ovc2_ioctl_spi_xfer sx;
      if (copy_from_user(&sx, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      rc = ovc2_spi_xfer(sx.bus, sx.dir, sx.reg_addr, sx.reg_val);
      //ovc2_print_regs();
      if (rc < 0)  // if we had an error, just return it to userland
        return rc;
      // otherwise, give the received register value back to userland
      sx.reg_val = rc;
      if (copy_to_user((void *)ioctl_param, &sx, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return 0;  // success
    }
    case OVC2_IOCTL_ENABLE_REG_RAM:
    {
      struct ovc2_ioctl_enable_reg_ram e;
      if (copy_from_user(&e, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_enable_reg_ram(e.enable ? true : false);
    }
    case OVC2_IOCTL_READ_PIO:
    {
      struct ovc2_ioctl_read_pio rp;
      if (copy_from_user(&rp, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      rp.data = ovc2_read_pio(rp.channel);
      if (copy_to_user((void *)ioctl_param, &rp, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return 0;  // success
    }
    case OVC2_IOCTL_BITSLIP:
    {
      struct ovc2_ioctl_bitslip bs;
      if (copy_from_user(&bs, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_bitslip(bs.channels);
    }
    case OVC2_IOCTL_IMU_SET_MODE:
    {
      struct ovc2_ioctl_imu_set_mode ism;
      if (copy_from_user(&ism, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_imu_set_mode(ism.mode);
    }
    case OVC2_IOCTL_CAM_SET_MODE:
    {
      struct ovc2_ioctl_cam_set_mode csm;
      if (copy_from_user(&csm, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_cam_set_mode(csm.mode);
    }
    case OVC2_IOCTL_SET_SYNC_TIMING:
    {
      struct ovc2_ioctl_set_sync_timing sst;
      if (copy_from_user(&sst, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_set_sync_timing(sst.imu_decimation);
    }
    case OVC2_IOCTL_SET_EXPOSURE:
    {
      struct ovc2_ioctl_set_exposure se;
      if (copy_from_user(&se, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_set_exposure(se.exposure_usec);
    }
    case OVC2_IOCTL_SET_AST_PARAMS:
    {
      struct ovc2_ioctl_set_ast_params sap;
      if (copy_from_user(&sap, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;
      return ovc2_set_ast_params(sap.threshold);
    }
    default:
    {
      printk(KERN_ERR "ovc2_core: unknown ioctl: 0x%08x\n",
        (unsigned)ioctl_num);
      return -EINVAL;
    }
  }
}

struct file_operations ovc2_core_fops = {
  .owner          = THIS_MODULE,
  .open           = ovc2_core_open,
  .release        = ovc2_core_release,
  .unlocked_ioctl = ovc2_core_ioctl,
};

///////////////////////////////////////////////////////////////////////
int ovc2_imu_open(struct inode *inode, struct file *fp)
{
  //printk(KERN_INFO "ovc2_imu_open()\n");
  return 0;
}

int ovc2_imu_release(struct inode *inode, struct file *file)
{
  //printk(KERN_INFO "ovc2_imu_release()\n");
  iowrite32(0x0, ovc2_core.bar3_addr);  // clear the IMU auto-poll bit
  return 0;  // success
}

ssize_t ovc2_imu_read(struct file *f, char __user *buf, size_t count,
                      loff_t *f_pos)
{
  const int READ_LEN = sizeof(struct ovc2_imu_data);
  //printk(KERN_INFO "ovc2_imu_read() %d bytes\n", (int)count);
  reinit_completion(&ovc2_core.imu_done);
  if (!wait_for_completion_timeout(&ovc2_core.imu_done, 1 * HZ))
    return -ETIMEDOUT;
  // copy latest imu read into struct
  if (count < READ_LEN)
    return -ENOBUFS;
  if (copy_to_user((void *)buf, &ovc2_core.imu_data, READ_LEN))
    return -EACCES;
  return READ_LEN;
}

struct file_operations ovc2_imu_fops = {
  .owner   = THIS_MODULE,
  .open    = ovc2_imu_open,
  .release = ovc2_imu_release,
  .read    = ovc2_imu_read
};

///////////////////////////////////////////////////////////////////////
int ovc2_cam_open(struct inode *inode, struct file *fp)
{
  //printk(KERN_INFO "ovc2_cam_open()\n");
  return 0;
}

int ovc2_cam_release(struct inode *inode, struct file *file)
{
  ovc2_set_bit(OVC2_REG_PCIE_PIO, 8, false);  // clear the dma-enable bit
  printk(KERN_INFO "ovc2_cam_release()\n");
  return 0;  // success
}

ssize_t ovc2_cam_read(struct file *f, char __user *buf, size_t count,
                      loff_t *f_pos)
{
  //printk(KERN_INFO "ovc2_cam_read()\n");
  reinit_completion(&ovc2_core.cam_done);
  if (!wait_for_completion_timeout(&ovc2_core.cam_done, 2 * HZ))
    return -ETIMEDOUT;
  dma_sync_single_for_cpu(
      &ovc2_core.pci_dev->dev,
      ovc2_core.cam_dma_addr,
      OVC2_CAM_DMA_BUF_SIZE,  // pixels + 256k misc stuff
      DMA_FROM_DEVICE);
  return 0;
}

static int ovc2_cam_mmap(struct file *f, struct vm_area_struct *vma)
{
  if (remap_pfn_range(vma, vma->vm_start,
      virt_to_phys(ovc2_core.cam_dma_buf) >> PAGE_SHIFT,
      vma->vm_end - vma->vm_start,
      vma->vm_page_prot)) {
    printk(KERN_ERR "ovc2_core: OH NO remap_pfn_range() failed\n");
    return -EAGAIN;
  }
  printk(KERN_INFO "ovc2_core: mmap remap_pfn_range() successful\n");
  return 0;
}

struct file_operations ovc2_cam_fops = {
  .owner   = THIS_MODULE,
  .open    = ovc2_cam_open,
  .release = ovc2_cam_release,
  .read    = ovc2_cam_read,
  .mmap    = ovc2_cam_mmap
};

///////////////////////////////////////////////////////////////////////
static int ovc2_pci_probe(
  struct pci_dev *probe_dev, const struct pci_device_id *id)
{
  int rc = 0;
  printk(KERN_INFO "ovc2_core: probing PCI (0x%04x, 0x%04x)\n", vid, did);

  if (probe_dev->vendor != vid || probe_dev->device != did)
    return -ENODEV;  // bye bye
  ovc2_core.pci_dev = probe_dev;
  rc = pci_enable_device(ovc2_core.pci_dev);
  if (rc) {
    printk(KERN_ERR "ovc2_core: pci_enable_device() failed\n");
    return rc;
  }
  rc = pci_request_regions(ovc2_core.pci_dev, "ovc2_core");
  if (rc) {
    printk(KERN_ERR "pci_request_regions() failed\n");
    return rc;
  }
  pci_set_master(ovc2_core.pci_dev);
  pci_set_dma_mask(ovc2_core.pci_dev, DMA_BIT_MASK(64));
  pci_set_consistent_dma_mask(ovc2_core.pci_dev, DMA_BIT_MASK(64));
  ovc2_core.bar0_addr = pci_iomap(ovc2_core.pci_dev, 0, 0);
  ovc2_core.bar2_addr = pci_iomap(ovc2_core.pci_dev, 2, 0);
  ovc2_core.bar3_addr = pci_iomap(ovc2_core.pci_dev, 3, 0);
  ovc2_core.cam_dma_buf = kmalloc(OVC2_CAM_DMA_BUF_SIZE, GFP_KERNEL);
  printk(KERN_INFO "ovc2_core: cam buf addr: 0x%px\n", ovc2_core.cam_dma_buf);
  ovc2_core.cam_dma_addr = dma_map_single(
      &ovc2_core.pci_dev->dev, ovc2_core.cam_dma_buf,
      OVC2_CAM_DMA_BUF_SIZE, DMA_FROM_DEVICE);
  if (dma_mapping_error(&ovc2_core.pci_dev->dev, ovc2_core.cam_dma_addr)) {
    printk(KERN_ERR "ovc2_core: ahhhh dma_mapping_error() !!!\n");
  }
  else {
    printk(KERN_INFO "ovc2_core: cam_dma_addr: 0x%llx\n",
        ovc2_core.cam_dma_addr);
  }
  init_completion(&ovc2_core.cam_done);
  init_completion(&ovc2_core.imu_done);
  rc = pci_enable_msi_range(ovc2_core.pci_dev, 1, 1);
  // todo: check return value and figure out what to do if it's not 1
  rc = request_irq(ovc2_core.pci_dev->irq, ovc2_irq_handler, 0, "ovc2",
      &ovc2_core);
  if (rc)
    printk(KERN_ERR "ovc2_core: request_irq returned %d\n", rc);
  iowrite32(0x3, ovc2_core.bar0_addr + 0x50);  // enable MSI interrupts {0,1}
  printk(KERN_INFO "ovc2_core: bar0_addr = 0x%px\n", ovc2_core.bar0_addr);
  printk(KERN_INFO "ovc2_core: bar2_addr = 0x%px\n", ovc2_core.bar2_addr);
  printk(KERN_INFO "ovc2_core: bar3_addr = 0x%px\n", ovc2_core.bar3_addr);
  printk(KERN_INFO "ovc2_core: device (0x%04x, 0x%04x) enabled\n", vid, did);
  return 0;
}

static void ovc2_pci_remove(struct pci_dev *remove_dev)
{
  if (remove_dev != ovc2_core.pci_dev) {
    printk(KERN_ERR "ovc2_core: ovc2_pci_remove() argument is not pci_dev\n");
    return;
  }
  iowrite32(0, ovc2_core.bar0_addr + 0x50);  // disable all MSI interrupts
  msleep(10);  // wait for irq to be done (?) i dunno. probably won't swap?
  if (ovc2_core.pci_dev->irq)
    free_irq(ovc2_core.pci_dev->irq, &ovc2_core);
  pci_disable_msi(ovc2_core.pci_dev);
  dma_unmap_single(&ovc2_core.pci_dev->dev, ovc2_core.cam_dma_addr,
      OVC2_CAM_DMA_BUF_SIZE, DMA_FROM_DEVICE);
  kfree(ovc2_core.cam_dma_buf);
  pci_iounmap(ovc2_core.pci_dev, ovc2_core.bar0_addr);
  pci_iounmap(ovc2_core.pci_dev, ovc2_core.bar2_addr);
  pci_iounmap(ovc2_core.pci_dev, ovc2_core.bar3_addr);
  pci_disable_device(ovc2_core.pci_dev);
  pci_release_regions(ovc2_core.pci_dev);
}

static struct pci_device_id ovc2_pci_id_table[] = {
  { PCI_DEVICE(PCI_ANY_ID, PCI_ANY_ID), },
  { 0, }
};
MODULE_DEVICE_TABLE(pci, ovc2_pci_id_table);

static struct pci_driver ovc2_pci_driver = {
  .name = "ovc2",
  .id_table = ovc2_pci_id_table,
  .probe = ovc2_pci_probe,
  .remove = ovc2_pci_remove
};

///////////////////////////////////////////////////////////////////////

#define DEVICE_NAME "ovc2_core"
#define CLASS_NAME  "ovc2_core"

static int __init ovc2_core_init(void)
{
  int rc;
  dev_t dev_alloc;

  rc = alloc_chrdev_region(&dev_alloc, 0, OVC2_CHRDEV_COUNT, "ovc2");
  if (rc) {
    printk(KERN_ERR "ovc2_core: alloc_chrdev_revion() failed\n");
    return rc;
  }
  ovc2_core.major = MAJOR(dev_alloc);
  printk(KERN_INFO "ovc2_core: alloc'ed major number %d\n", ovc2_core.major);

  cdev_init(&ovc2_core.cdev_core, &ovc2_core_fops);
  cdev_init(&ovc2_core.cdev_imu , &ovc2_imu_fops);
  cdev_init(&ovc2_core.cdev_cam , &ovc2_cam_fops);
  ovc2_core.cdev_core.owner = THIS_MODULE;
  rc = cdev_add(
    &ovc2_core.cdev_core, MKDEV(ovc2_core.major, OVC2_MINOR_CORE), 1);
  if (rc) {
    printk(KERN_ERR "ovc2_core: couldn't add cdev_core");
    return rc;
  }

  rc = cdev_add(
    &ovc2_core.cdev_imu, MKDEV(ovc2_core.major, OVC2_MINOR_IMU), 1);
  if (rc) {
    printk(KERN_ERR "ovc2_core: couldn't add cdev_imu");
    return rc;
  }

  rc = cdev_add(
    &ovc2_core.cdev_cam, MKDEV(ovc2_core.major, OVC2_MINOR_CAM), 1);
  if (rc) {
    printk(KERN_ERR "ovc2_core: couldn't add cdev_cam");
    return rc;
  }
  printk(KERN_INFO "ovc2_core: cdev's created successfully\n");

/*
  ovc2_core.dev_class = class_create(THIS_MODULE, CLASS_NAME);
  if (IS_ERR(ovc2_core.dev_class)) {
    unregister_chrdev(ovc2_core.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_core: class_create() failed\n");
    return PTR_ERR(ovc2_core.dev_class);
  }

  ovc2_core.device = device_create(
    ovc2_core.dev_class, NULL, MKDEV(ovc2_core.major_number, OVC2_MINOR_CORE),
    NULL, DEVICE_NAME);
  if (IS_ERR(ovc2_core.device)) {
    class_destroy(ovc2_core.dev_class);
    unregister_chrdev(ovc2_core.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_core: device_create() failed for core\n");
    return PTR_ERR(ovc2_core.device);
  }
  printk(KERN_INFO "ovc2_core: devices created successfully\n");

*/
  rc = pci_register_driver(&ovc2_pci_driver);
  if (rc) {
    //unregister_chrdev(ovc2_core.major, DEVICE_NAME);
    printk(KERN_ERR "ovc2_core: PCI driver registration failed\n");
    return rc;
  }

  atomic_set(&ovc2_core.is_available, 1);

  return 0;
}

static void __exit ovc2_core_exit(void)
{
  //device_destroy(ovc2_core.dev_class, MKDEV(ovc2_core.major_number, 0));
  //class_unregister(ovc2_core.dev_class);
  //class_destroy(ovc2_core.dev_class);
  cdev_del(&ovc2_core.cdev_core);
  cdev_del(&ovc2_core.cdev_imu);
  cdev_del(&ovc2_core.cdev_cam);
  unregister_chrdev_region(MKDEV(ovc2_core.major, 0), OVC2_CHRDEV_COUNT);
  pci_unregister_driver(&ovc2_pci_driver);
  printk(KERN_INFO "ovc2_core: removal complete\n");
}

module_init(ovc2_core_init);
module_exit(ovc2_core_exit);

MODULE_AUTHOR("Morgan Quigley <morgan@openrobotics.org>");
MODULE_DESCRIPTION("Kernel driver for the Open Vision Computer (OVC), rev. 2");
MODULE_VERSION("0.0.1");
MODULE_LICENSE("Dual BSD/GPL");
