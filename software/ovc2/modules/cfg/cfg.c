#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/spi/spi.h>
//#include <linux/types.h>

struct cfg_dev {
  struct spi_device *spi_device;
  struct cdev cdev;
  dev_t dev;
  unsigned major;
};
static struct cfg_dev cfg_dev;
//////////////////////////////////////////////////////////////////////

int cfg_open(struct inode *inode, struct file *fp)
{
  return 0;  // success  
}

ssize_t cfg_write(struct file *f, const char __user *p, size_t count, loff_t *pos)
{
  u8 *tx_buf;
  tx_buf = kmalloc(count, GFP_KERNEL);
  if (!tx_buf) {
    printk("cfg_write(): kmalloc returned NULL\n");
    return -EIO;
  }
  printk("cfg_write(): allocated %d bytes of kernel memory\n",
    (int)ksize(tx_buf));
  kfree(tx_buf);
  return count;
}

int cfg_release(struct inode *inode, struct file *file)
{
  return 0;  // success
}

static long cfg_ioctl(struct file *file, unsigned int ioctl_num,
  unsigned long ioctl_param)
{
  return -EINVAL;  // no ioctl defined yet
}

struct file_operations cfg_fops = {
  .owner          = THIS_MODULE,
  //.read           = cfg_read,
  .write          = cfg_write,
  .open           = cfg_open,
  .release        = cfg_release,
  .unlocked_ioctl = cfg_ioctl,
};

static int __init cfg_init(void)
{
  int rc;
  u32 msg = 0x12345678;
  struct spi_master *master;
  struct spi_board_info board_info = {
    //.modalias = "cfg",
    .max_speed_hz = 10000000,
    .bus_num = 3,
    .chip_select = 0,
    .mode = 0
  };

  rc = alloc_chrdev_region(&cfg_dev.dev, 0, 1, "cfg");
  if (rc) {
    printk(KERN_ERR "cfg: allocation of char device number failed\n");
    return rc;
  }
  cfg_dev.major = MAJOR(cfg_dev.dev);
  cdev_init(&cfg_dev.cdev, &cfg_fops);
  rc = cdev_add(&cfg_dev.cdev, cfg_dev.dev, 1);
  if (rc) {
    printk(KERN_ERR "cfg: cdev_add() failed\n");
    return rc;
  }

  master = spi_busnum_to_master(board_info.bus_num);
  if (!master) {
    printk("spi_busnum_to_master() failed\n");
    return -ENODEV;
  }
  cfg_dev.spi_device = spi_new_device(master, &board_info);
  if (!cfg_dev.spi_device) {
    printk("spi_new_device() failed\n");
    return -ENODEV;
  }
  cfg_dev.spi_device->bits_per_word = 8;
  rc = spi_setup(cfg_dev.spi_device);
  if (rc) {
    printk("spi_setup() failed\n");
    spi_unregister_device(cfg_dev.spi_device);
    return -ENODEV;
  }
  spi_write(cfg_dev.spi_device, &msg, 4);
  return 0;
}

static void __exit cfg_exit(void)
{
  cdev_del(&cfg_dev.cdev);
  unregister_chrdev_region(MKDEV(cfg_dev.major, 0), 1);
  if (cfg_dev.spi_device) {
    spi_unregister_device(cfg_dev.spi_device);
  }
}

module_init(cfg_init);
module_exit(cfg_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Morgan Quigley <morgan@openrobotics.org>");
MODULE_DESCRIPTION("SPI configuration driver for Altera Cyclone 10 GX");
