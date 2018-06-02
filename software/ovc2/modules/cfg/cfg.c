#include <linux/init.h>
#include <linux/module.h>
#include <linux/spi/spi.h>

static struct spi_device *device;

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
  master = spi_busnum_to_master(board_info.bus_num);
  if (!master) {
    printk("spi_busnum_to_master() failed\n");
    return -ENODEV;
  }
  device = spi_new_device(master, &board_info);
  if (!device) {
    printk("spi_new_device() failed\n");
    return -ENODEV;
  }
  device->bits_per_word = 8;
  rc = spi_setup(device);
  if (rc) {
    printk("spi_setup() failed\n");
    spi_unregister_device(device);
    return -ENODEV;
  }
  spi_write(device, &msg, 4);
  return 0;
}

static void __exit cfg_exit(void)
{
  if (device) {
    spi_unregister_device(device);
  }
}

module_init(cfg_init);
module_exit(cfg_exit);

MODULE_LICENSE("Dual BSD/GPL");
MODULE_AUTHOR("Morgan Quigley <morgan@openrobotics.org>");
MODULE_DESCRIPTION("SPI configuration driver for Altera Cyclone 10 GX");
