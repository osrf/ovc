#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/spi/spi.h>
#include <linux/uaccess.h>

#define OVC2_CFG_WRITE_BUF_LEN 4096

struct ovc2_cfg {
  struct spi_device *spi_device;
  struct cdev cdev;
  int major_number;
  struct class *dev_class;
  struct device *device;
  u8 *write_buf;
};
static struct ovc2_cfg ovc2_cfg;
//////////////////////////////////////////////////////////////////////


int ovc2_cfg_open(struct inode *inode, struct file *fp)
{
  /*
  u8 msg[2] = {0x01, 0x02};
  spi_write(cfg.spi_device, msg, 2);
  spi_write(cfg.spi_device, msg, 2);
  */
  return 0;  // success  
}

ssize_t ovc2_cfg_write(struct file *f, const char __user *p, size_t count, loff_t *pos)
{
  int rc, n_remaining, tx_len;

  printk(KERN_INFO "ovc2_cfg: ovc2_cfg_write(%d)\n", (int)count);
  n_remaining = (int)count;
  while (n_remaining > 0) {
    if (n_remaining > OVC2_CFG_WRITE_BUF_LEN)
      tx_len = OVC2_CFG_WRITE_BUF_LEN;
    else
      tx_len = n_remaining;
    rc = copy_from_user(ovc2_cfg.write_buf, p, tx_len); 
    n_remaining -= tx_len;
    rc = spi_write(ovc2_cfg.spi_device, ovc2_cfg.write_buf, tx_len);
    if (rc != 0) {
      printk(KERN_ERR "ovc2_cfg: spi_write() returned %d\n", rc);
      break;
    }
    p += tx_len;
    //printk(KERN_INFO "ovc2_cfg:  tx_len = %d  spi_write() rc = %d\n", tx_len, rc);
  }

  /*
  u8 *tx_buf;
  tx_buf = kmalloc(count, GFP_KERNEL);
  if (!tx_buf) {
    printk("ovc2_cfg_write(): kmalloc returned NULL\n");
    return -EIO;
  }
  printk("ovc2_cfg_write(): allocated %d bytes of kernel memory\n",
    (int)ksize(tx_buf));
  kfree(tx_buf);
  */
  // may need to use spi_sync_locked() ?
  // in order to not release SCLK/MOSI between 128k bursts
  // if so, need to copy out helper code from /include/linux/spi/spi.h
  // (the body of spi_write() is just a few lines)
  //rc = spi_write(ovc2_cfg.spi_device, p, count); //&msg, 4);
  //if (
  return count;
}

int ovc2_cfg_release(struct inode *inode, struct file *file)
{
  return 0;  // success
}

static long ovc2_cfg_ioctl(struct file *file, unsigned int ioctl_num,
  unsigned long ioctl_param)
{
  return -EINVAL;  // no ioctl defined yet
}

struct file_operations ovc2_cfg_fops = {
  .owner          = THIS_MODULE,
  //.read           = ovc2_cfg_read,
  .write          = ovc2_cfg_write,
  .open           = ovc2_cfg_open,
  .release        = ovc2_cfg_release,
  .unlocked_ioctl = ovc2_cfg_ioctl,
};

#define DEVICE_NAME "ovc2_cfg"
#define CLASS_NAME  "ovc2_cfg"

static int __init ovc2_cfg_init(void)
{
  int rc;
  //u32 msg = 0x12345678;
  struct spi_master *master;
  struct spi_board_info board_info = {
    //.modalias = "ovc2_cfg",
    .max_speed_hz = 25000000,  // faster than 25 MHz doesn't have any effect
    .bus_num = 3,
    .chip_select = 0,
    .mode = SPI_LSB_FIRST
  };

  ovc2_cfg.major_number = register_chrdev(0, DEVICE_NAME, &ovc2_cfg_fops);
  if (ovc2_cfg.major_number < 0) {
    printk(KERN_ERR "ovc2_cfg: register_chrdev() failed\n");
    return ovc2_cfg.major_number;
  }
  printk(KERN_INFO "ovc2_cfg: registered major number %d\n", ovc2_cfg.major_number);

  ovc2_cfg.dev_class = class_create(THIS_MODULE, CLASS_NAME);
  if (IS_ERR(ovc2_cfg.dev_class)) {
    unregister_chrdev(ovc2_cfg.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_cfg: class_create() failed\n");
    return PTR_ERR(ovc2_cfg.dev_class);
  }

  ovc2_cfg.device = device_create(ovc2_cfg.dev_class, NULL, MKDEV(ovc2_cfg.major_number, 0),
    NULL, DEVICE_NAME);
  if (IS_ERR(ovc2_cfg.device)) {
    class_destroy(ovc2_cfg.dev_class);
    unregister_chrdev(ovc2_cfg.major_number, DEVICE_NAME);
    printk(KERN_ERR "ovc2_cfg: device_create() failed\n");
    return PTR_ERR(ovc2_cfg.device);
  }
  printk(KERN_INFO "ovc2_cfg: device created successfully\n");

  master = spi_busnum_to_master(board_info.bus_num);
  if (!master) {
    printk("spi_busnum_to_master() failed\n");
    return -ENODEV;
  }
  ovc2_cfg.spi_device = spi_new_device(master, &board_info);
  if (!ovc2_cfg.spi_device) {
    printk("spi_new_device() failed\n");
    return -ENODEV;
  }
  ovc2_cfg.spi_device->bits_per_word = 8;
  rc = spi_setup(ovc2_cfg.spi_device);
  if (rc) {
    printk("spi_setup() failed\n");
    spi_unregister_device(ovc2_cfg.spi_device);
    return -ENODEV;
  }

  ovc2_cfg.write_buf = kmalloc(OVC2_CFG_WRITE_BUF_LEN, GFP_KERNEL);
  return 0;
}

static void __exit ovc2_cfg_exit(void)
{
  spi_unregister_device(ovc2_cfg.spi_device);
  device_destroy(ovc2_cfg.dev_class, MKDEV(ovc2_cfg.major_number, 0));
  class_unregister(ovc2_cfg.dev_class);
  class_destroy(ovc2_cfg.dev_class);
  unregister_chrdev(ovc2_cfg.major_number, DEVICE_NAME);
  if (ovc2_cfg.write_buf)
    kfree(ovc2_cfg.write_buf);
  printk(KERN_INFO "ovc2_cfg: removal complete\n");
}

module_init(ovc2_cfg_init);
module_exit(ovc2_cfg_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Morgan Quigley <morgan@openrobotics.org>");
MODULE_DESCRIPTION("SPI configuration driver for Altera Cyclone 10 GX");
