#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/pci.h>
#include <asm/spinlock.h>
#include <asm/uaccess.h>
#include "ovc2_ioctl.h"
//#include <linux/uaccess.h>

static unsigned short vid = 0x1234;
static unsigned short did = 0x5678;
module_param(vid, ushort, S_IRUGO);
module_param(did, ushort, S_IRUGO);

struct ovc2_core {
  struct cdev cdev;
  int major_number;
  struct pci_dev *pci_dev;
  void __iomem *bar0_addr;
  atomic_t is_available;
  struct class *dev_class;
  struct device *device;
};
static struct ovc2_core ovc2_core;
//////////////////////////////////////////////////////////////////////
DEFINE_SPINLOCK(pio_spinlock);
//////////////////////////////////////////////////////////////////////

int ovc2_core_open(struct inode *inode, struct file *fp)
{
  if (!atomic_dec_and_test(&ovc2_core.is_available)) {
    atomic_inc(&ovc2_core.is_available);
    return -EBUSY;
  }
  return 0;  // success  
}

int ovc2_core_release(struct inode *inode, struct file *file)
{
  atomic_inc(&ovc2_core.is_available);
  return 0;  // success
}

      //u32 pio_prev_value;

static void ovc2_set_bit(uint32_t reg_idx, uint8_t bit_idx, uint8_t state)
{
  if (reg_idx == OVC2_REG_PCIE_PIO) {
    uint32_t pio_prev_value;
    unsigned long flags;
    spin_lock_irqsave(&pio_spinlock, flags);
    //pio_prev_value = ioread32(
    spin_unlock_irqrestore(&pio_spinlock, flags);
  }
  else {
    // print warning message to kernel log? or just ignore?
  }
}

static long ovc2_core_ioctl(
  struct file *file, unsigned int ioctl_num, unsigned long ioctl_param)
{
  switch (ioctl_num)
  {
    case OVC2_IOCTL_SET_BIT:
    {
      struct ovc2_ioctl_set_bit sb;
      if (copy_from_user(&sb, (void *)ioctl_param, _IOC_SIZE(ioctl_num)))
        return -EACCES;  // uh oh
      ovc2_set_bit(sb.reg_idx, sb.bit_idx, sb.state);
    }
  }
  return -EINVAL;  // no ioctl defined yet
}

struct file_operations ovc2_core_fops = {
  .owner          = THIS_MODULE,
  .open           = ovc2_core_open,
  .release        = ovc2_core_release,
  .unlocked_ioctl = ovc2_core_ioctl,
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
  printk(KERN_INFO "ovc2_core: enabled device (0x%04x, 0x%04x)\n", vid, did);
  rc = pci_request_regions(ovc2_core.pci_dev, "ovc2_core");
  if (rc) {
    printk(KERN_ERR "pci_request_regions() failed\n");
    return rc;
  }
  pci_set_master(ovc2_core.pci_dev);
  pci_set_dma_mask(ovc2_core.pci_dev, DMA_BIT_MASK(64));
  pci_set_consistent_dma_mask(ovc2_core.pci_dev, DMA_BIT_MASK(64));
  ovc2_core.bar0_addr = pci_iomap(ovc2_core.pci_dev, 0, 0);
  printk(KERN_INFO "bar0_addr = 0x%px\n", ovc2_core.bar0_addr);

  return 0;
}

static void ovc2_pci_remove(struct pci_dev *remove_dev)
{
  if (remove_dev != ovc2_core.pci_dev) {
    printk(KERN_ERR "ovc2_core: ovc2_pci_remove() argument is not pci_dev\n");
    return;
  }
  pci_iounmap(ovc2_core.pci_dev, ovc2_core.bar0_addr);
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

  ovc2_core.major_number = register_chrdev(0, DEVICE_NAME, &ovc2_core_fops);
  if (ovc2_core.major_number < 0) {
    printk(KERN_ERR "ovc2_core: register_chrdev() failed\n");
    return ovc2_core.major_number;
  }
  printk(KERN_INFO "ovc2_core: registered major number %d\n",
    ovc2_core.major_number);

  ovc2_core.dev_class = class_create(THIS_MODULE, CLASS_NAME);
  if (IS_ERR(ovc2_core.dev_class)) {
    unregister_chrdev(ovc2_core.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_core: class_create() failed\n");
    return PTR_ERR(ovc2_core.dev_class);
  }

  ovc2_core.device = device_create(
    ovc2_core.dev_class, NULL, MKDEV(ovc2_core.major_number, 0),
    NULL, DEVICE_NAME);
  if (IS_ERR(ovc2_core.device)) {
    class_destroy(ovc2_core.dev_class);
    unregister_chrdev(ovc2_core.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_core: device_create() failed\n");
    return PTR_ERR(ovc2_core.device);
  }
  printk(KERN_INFO "ovc2_core: device created successfully\n");

  rc = pci_register_driver(&ovc2_pci_driver);
  if (rc) {
    unregister_chrdev(ovc2_core.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_core: PCI driver registration failed\n");
    return rc;
  }

  atomic_set(&ovc2_core.is_available, 1);

  return 0;
}

static void __exit ovc2_core_exit(void)
{
  device_destroy(ovc2_core.dev_class, MKDEV(ovc2_core.major_number, 0));
  class_unregister(ovc2_core.dev_class);
  class_destroy(ovc2_core.dev_class);
  unregister_chrdev(ovc2_core.major_number, DEVICE_NAME);
  pci_unregister_driver(&ovc2_pci_driver);
  printk(KERN_INFO "ovc2_core: removal complete\n");
}

module_init(ovc2_core_init);
module_exit(ovc2_core_exit);

MODULE_AUTHOR("Morgan Quigley <morgan@openrobotics.org>");
MODULE_DESCRIPTION("Kernel driver for the Open Vision Computer (OVC), rev. 2");
MODULE_VERSION("0.0.1");
MODULE_LICENSE("Dual BSD/GPL");
