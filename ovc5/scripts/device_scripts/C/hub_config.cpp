#include <iostream>
#include <string>

extern "C" {
#include <fcntl.h>
#include <i2c/smbus.h>
#include <linux/i2c.h>
#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <unistd.h>
}

class HubConfig
{
private:
  int i2c_fd;
  const uint16_t ADDR = 0x2D;
  const uint32_t PID_REGADDR = 0xBF803002;
  const uint16_t PID = 0x5642;

public:
  HubConfig(int i2c_dev = 10)
  {
    std::string filename = "/dev/i2c-" + std::to_string(i2c_dev);
    i2c_fd = open(filename.c_str(), O_RDWR);
    if (i2c_fd < 0)
    {
      std::cout << "Failed opening i2c file" << std::endl;
      return;
    }
    ioctl(i2c_fd, I2C_SLAVE, ADDR);

  }

  void boot()
  {
    uint8_t boot_cmd[] = {0xAA, 0x56, 0x00}; // Only last two bytes
    //i2c_smbus_write_block_data(i2c_fd, 0xAA, 2, boot_cmd);
    write(i2c_fd, boot_cmd, sizeof(boot_cmd));
    // Sleep for a bit to allow the hub to boot
    usleep(200000);
  }

  uint16_t read_register(uint32_t reg_addr)
  {
    // Ref table 271, 272 and 273 from AN2935
    // Write the register address

    uint8_t setup_data[] = 
      {0, // Two 0 in LSBs
      0,
      6, // Length of packet
      1, // command read configuration register
      2, // Number of bytes to read (16 bit registers)
      (reg_addr >> 24) & 0xFF, // 32 bit address
      (reg_addr >> 16) & 0xFF,
      (reg_addr >> 8) & 0xFF,
      reg_addr & 0xFF};
    if (write(i2c_fd, setup_data, sizeof(setup_data)) < 0)
      std::cout << "Error in writing setup data packet" << std::endl;

    // Step 2, execute configuration register access command
    uint8_t cmd_data[3] = {0x99, 0x37, 0x00};
    if (write(i2c_fd, cmd_data, sizeof(cmd_data)) < 0)
      std::cout << "Error in writing setup data packet" << std::endl;

    // Now read smbus block data, read 2 bytes, combined read / write
    uint8_t rd_write_data[] = {0x00, 0x06};
    uint8_t rx_buf[3] = {0};
    struct i2c_msg msgs[] =
    {
      {
        .addr = ADDR,
        .flags = 0,
        .len = sizeof(rd_write_data),
        .buf = rd_write_data
      },
      {
        .addr = ADDR,
        .flags = I2C_M_RD,
        .len = sizeof(rx_buf),
        .buf = rx_buf,
      }
    };
    // Prepare the transaction
    struct i2c_rdwr_ioctl_data transaction {
      .msgs = msgs,
      .nmsgs = 2
    };
    // Execute the transaction
    int ioctl_res = ioctl(i2c_fd, I2C_RDWR, &transaction);
    if (ioctl_res < 0)
    {
      std::cout << "Error in ioctl rd/wr transaction " << ioctl_res << std::endl;
    }

    //for (int i = 0; i < sizeof(rx_buf); ++i)
    //  std::cout << (int)rx_buf[i] << " ";
    std::cout << std::endl;
    // TODO convert to 16 bit value and return
    uint16_t retval = (uint16_t)rx_buf[1] << 8 | rx_buf[2];
    return retval;
  }

  bool probe_chip()
  {
    auto probed_pid = read_register(PID_REGADDR);
    if (probed_pid != PID)
    {
      std::cout << "Failed reading product ID, expected " << std::hex << PID <<
        " read " << probed_pid << std::endl; 
      return false;
    }
    return true;
  }

  void write_register(uint32_t reg_addr, uint8_t reg_val)
  {
    uint8_t setup_data[] = 
      {0, // Two 0 in LSBs
      0,
      7, // Length of packet
      0, // command write configuration register
      1, // Number of bytes to write (8 bit registers)
      (reg_addr >> 24) & 0xFF, // 32 bit address, this is MSB first
      (reg_addr >> 16) & 0xFF,
      (reg_addr >> 8) & 0xFF,
      reg_addr & 0xFF,
      reg_val & 0xFF}; // 8 bit value, this is LSB first

    if (write(i2c_fd, setup_data, sizeof(setup_data)) < 0)
      std::cout << "Error in writing setup data packet" << std::endl;

    // Step 2, execute configuration register access command
    uint8_t cmd_data[3] = {0x99, 0x37, 0x00};
    if (write(i2c_fd, cmd_data, sizeof(cmd_data)) < 0)
      std::cout << "Error in executing command" << std::endl;

  }
};

// TODO for final OVC
// BF80_30FA port swap for P6
// Flexconnect

int main(int argc, char **argv)
{
  std::cout << "Initializing" << std::endl;
  HubConfig hub;
  hub.probe_chip();
  //auto ret = hub.read_register(0xBF803002);
  //std::cout << std::hex << ret << std::endl;
  //std::cout << "USB3 hub control 2 " << std::hex << hub.read_register(0xBF803814) << std::endl;
  // Write to it to enable
  //hub.write_register(0xBF803841, 0x01);
  //std::cout << "after write USB3 hub control 2 " << std::hex << hub.read_register(0xBF803841) << std::endl;
  // Status
  /*
  std::cout << "USB3 hub status is " << std::hex << hub.read_register(0xBF803851) << std::endl;
  std::cout << "USB3 suspend state is " << std::hex << hub.read_register(0xBF803857) << std::endl;
  std::cout << "runtime flags MSBs is " << std::hex << hub.read_register(0xBFD23400) << std::endl;
  std::cout << "runtime flags LSBs is " << std::hex << hub.read_register(0xBFD23402) << std::endl;
  */
  // Do loopback test
  // OK
  /*
  std::cout << "before write role switch delay " << std::hex << hub.read_register(0xBFD23450) << std::endl;
  hub.write_register(0xBFD23450, 0x12);
  std::cout << "after write role switch delay " << std::hex << hub.read_register(0xBFD23450) << std::endl;
  */
  // Time to configure flexconnect on port 1
  //std::cout << "PF6 GPIO register is " << std::hex << hub.read_register(0xBF800C09) << std::endl;
  //std::cout << "flex in p1 is " << std::hex << hub.read_register(0xBFD23442) << std::endl;
  // GPIO input status
  /*
  std::cout << "PIO input enable MSB is " << std::hex << hub.read_register(0xBF800918) << std::endl;
  // Enable input for pin PF6
  hub.write_register(0xBF800918, 0x40);
  std::cout << "PIO input value MSB is " << std::hex << hub.read_register(0xBF800938) << std::endl;
  // Enable output for PF7
  std::cout << "PIO output enable MSB is " << std::hex << hub.read_register(0xBF800908) << std::endl;
  hub.write_register(0xBF800908, 0x80);
  std::cout << "PF6 GPIO register is " << std::hex << hub.read_register(0xBF800C09) << std::endl;
  // Throw a pullup in the PF6 pin
  hub.write_register(0xBF800948, 0x40);
  */
  // Force VBUS_DET high
  /*
  hub.write_register(0xBFD23454, 0x40);
  // FLEX_IN on port 1, config gpio is PF6
  hub.write_register(0xBFD23442, 0x80);
  // Add indicator
  hub.write_register(0xBFD2344A, 0xC1);
  // Add flexconnect and role switch delays
  hub.write_register(0xBFD23455, 0x10);
  // Commented because datasheet is wrong, likely address is BFD23456
  //hub.write_register(0xBFD23450, 0x10);
  */
  // Given by microchip
  /*
  hub.write_register(0xBF800808, 0x1);
  //hub.read_register(0xBF800808);
  hub.write_register(0xBF800828, 0x1);
  hub.write_register(0xBF805400, 0x1);
  //hub.write_register(0xBF800829, 0x1);
  // Force VBUS_DET high
  hub.write_register(0xBFD23454, 0x40);
  */
  hub.boot();
  usleep(100000);
  return 0;
}
