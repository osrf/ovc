/*
 * Copyright (c) 2015 - 2016, Freescale Semiconductor, Inc.
 * Copyright 2016 - 2017, 2019 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include "fsl_device_registers.h"
#include "clock_config.h"
#include "board.h"

#include "ovc_hw_defs.h"

#include <stdio.h>
#include <stdlib.h>

#include "usb_device_config.h"
#include "usb.h"
#include "usb_device.h"

#include "usb_device_ch9.h"
#include "fsl_debug_console.h"

#include "camera_i2c.h"
#include "camera_gpio.h"
#include "imu_spi.h"
#include "usb_packetdef.h"

#include "usb_device_descriptor.h"

#if ((defined FSL_FEATURE_SOC_USBPHY_COUNT) && (FSL_FEATURE_SOC_USBPHY_COUNT > 0U))
#include "usb_phy.h"
#endif

void BOARD_InitHardware(void);
void USB_DeviceClockInit(void);
void USB_DeviceIsrEnable(void);
#if USB_DEVICE_CONFIG_USE_TASK
void USB_DeviceTaskFn(void *deviceHandle);
#endif

void BOARD_DbgConsole_Deinit(void);
void BOARD_DbgConsole_Init(void);
#include "pin_mux.h"
#include <stdbool.h>
#include "fsl_power.h"
/*******************************************************************************
 * Definitions
 ******************************************************************************/

/*******************************************************************************
 * Variables
 ******************************************************************************/
/* Data structure of virtual com device */
usb_device_handle usb_handle; /* USB device handle. */

usb_tx_packet_t tx_packet;
usb_rx_packet_t rx_packet;
volatile int packet_received = 0;

/* Data buffer for receiving and sending*/
USB_DMA_NONINIT_DATA_ALIGN(USB_DATA_ALIGN_SIZE) static uint8_t s_SetupOutBuffer[8];
/*******************************************************************************
 * Prototypes
 ******************************************************************************/

/*******************************************************************************
 * Code
 ******************************************************************************/
void USB1_IRQHandler(void)
{
    USB_DeviceLpcIp3511IsrFunction(usb_handle);
}

void USB_DeviceClockInit(void)
{
    /* enable USB IP clock */
    CLOCK_EnableUsbhs0PhyPllClock(kCLOCK_UsbPhySrcExt, BOARD_XTAL0_CLK_HZ);
    CLOCK_EnableUsbhs0DeviceClock(kCLOCK_UsbSrcUnused, 0U);
    USB_EhciPhyInit(USB_CONTROLLER_ID, BOARD_XTAL0_CLK_HZ, NULL);
    for (int i = 0; i < FSL_FEATURE_USBHSD_USB_RAM; i++)
    {
        ((uint8_t *)FSL_FEATURE_USBHSD_USB_RAM_BASE_ADDRESS)[i] = 0x00U;
    }

}
void USB_DeviceIsrEnable(void)
{
    uint8_t irqNumber;
    uint8_t usbDeviceIP3511Irq[] = USBHSD_IRQS;
    irqNumber                    = usbDeviceIP3511Irq[USB_CONTROLLER_ID - kUSB_ControllerLpcIp3511Hs0];
    /* Install isr, set priority, and enable IRQ. */
    NVIC_SetPriority((IRQn_Type)irqNumber, USB_DEVICE_INTERRUPT_PRIORITY);
    EnableIRQ((IRQn_Type)irqNumber);
}
/*!
 * @brief Bulk in pipe callback function.
 *
 * This function serves as the callback function for bulk in pipe.
 *
 * @param handle The USB device handle.
 * @param message The endpoint callback message
 * @param callbackParam The parameter of the callback.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
usb_status_t USB_DeviceCdcAcmBulkIn(usb_device_handle handle,
                                    usb_device_endpoint_callback_message_struct_t *message,
                                    void *callbackParam)
{
    usb_status_t error = kStatus_USB_Error;

    if ((message->length != 0) && (!(message->length % HS_BULK_OUT_PACKET_SIZE)))
    {
        /* If the last packet is the size of endpoint, then send also zero-ended packet,
         ** meaning that we want to inform the host that we do not have any additional
         ** data, so it can flush the output.
         */
        USB_DeviceSendRequest(handle, USB_BULK_IN_ENDPOINT, NULL, 0);
    }
    else if ((message->buffer != NULL) || ((message->buffer == NULL) && (message->length == 0)))
    {
        /* User: add your own code for send complete event */
        /* Schedule buffer for next receive event */
        USB_DeviceRecvRequest(handle, USB_BULK_OUT_ENDPOINT, rx_packet.data, HS_BULK_OUT_PACKET_SIZE);
    }
    return error;
}

/*!
 * @brief Bulk out pipe callback function.
 *
 * This function serves as the callback function for bulk out pipe.
 *
 * @param handle The USB device handle.
 * @param message The endpoint callback message
 * @param callbackParam The parameter of the callback.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
usb_status_t USB_DeviceCdcAcmBulkOut(usb_device_handle handle,
                                     usb_device_endpoint_callback_message_struct_t *message,
                                     void *callbackParam)
{
    packet_received++;
    usb_status_t error = kStatus_USB_Success;

    if (!message->length)
    {
        /* Schedule buffer for next receive event */
        USB_DeviceRecvRequest(handle, USB_BULK_OUT_ENDPOINT, rx_packet.data, HS_BULK_OUT_PACKET_SIZE);
    }
    return error;
}

/*!
 * @brief Get the setup packet buffer.
 *
 * This function provides the buffer for setup packet.
 *
 * @param handle The USB device handle.
 * @param setupBuffer The pointer to the address of setup packet buffer.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
usb_status_t USB_DeviceGetSetupBuffer(usb_device_handle handle, usb_setup_struct_t **setupBuffer)
{
    static uint32_t cdcVcomSetup[2];
    if (NULL == setupBuffer)
    {
        return kStatus_USB_InvalidParameter;
    }
    *setupBuffer = (usb_setup_struct_t *)&cdcVcomSetup;
    return kStatus_USB_Success;
}

/*!
 * @brief Get the setup packet data buffer.
 *
 * This function gets the data buffer for setup packet.
 *
 * @param handle The USB device handle.
 * @param setup The pointer to the setup packet.
 * @param length The pointer to the length of the data buffer.
 * @param buffer The pointer to the address of setup packet data buffer.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
usb_status_t USB_DeviceGetClassReceiveBuffer(usb_device_handle handle,
                                             usb_setup_struct_t *setup,
                                             uint32_t *length,
                                             uint8_t **buffer)
{
    if ((NULL == buffer) || ((*length) > sizeof(s_SetupOutBuffer)))
    {
        return kStatus_USB_InvalidRequest;
    }
    *buffer = s_SetupOutBuffer;
    return kStatus_USB_Success;
}

// NOOP
usb_status_t USB_DeviceConfigureRemoteWakeup(usb_device_handle handle, uint8_t enable)
{
    return kStatus_USB_InvalidRequest;
}

// NOOP
usb_status_t USB_DeviceProcessClassRequest(usb_device_handle handle,
                                           usb_setup_struct_t *setup,
                                           uint32_t *length,
                                           uint8_t **buffer)
{
    usb_status_t error = kStatus_USB_Success;
    return error;
}

/*!
 * @brief USB device callback function.
 *
 * This function handles the usb device specific requests.
 *
 * @param handle          The USB device handle.
 * @param event           The USB device event type.
 * @param param           The parameter of the device specific request.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
usb_status_t USB_DeviceCallback(usb_device_handle handle, uint32_t event, void *param)
{
    usb_status_t error = kStatus_USB_Error;
    uint8_t *temp8     = (uint8_t *)param;

    switch (event)
    {
        case kUSB_DeviceEventBusReset:
        {
            USB_DeviceControlPipeInit(usb_handle);
        }
        break;
        case kUSB_DeviceEventSetConfiguration:
        {
            if (USB_CONFIGURE_INDEX == (*temp8))
            {
                usb_device_endpoint_init_struct_t epInitStruct;
                usb_device_endpoint_callback_struct_t epCallback;

                /* Initiailize endpoints for bulk pipe */
                epCallback.callbackFn    = USB_DeviceCdcAcmBulkIn;
                epCallback.callbackParam = handle;

                epInitStruct.zlt          = 0;
                epInitStruct.interval     = 0U;
                epInitStruct.transferType = USB_ENDPOINT_BULK;
                epInitStruct.endpointAddress =
                    USB_BULK_IN_ENDPOINT | (USB_IN << USB_DESCRIPTOR_ENDPOINT_ADDRESS_DIRECTION_SHIFT);
                epInitStruct.maxPacketSize = HS_BULK_IN_PACKET_SIZE;

                USB_DeviceInitEndpoint(usb_handle, &epInitStruct, &epCallback);

                epCallback.callbackFn    = USB_DeviceCdcAcmBulkOut;
                epCallback.callbackParam = handle;

                epInitStruct.zlt          = 0;
                epInitStruct.interval     = 0U;
                epInitStruct.transferType = USB_ENDPOINT_BULK;
                epInitStruct.endpointAddress =
                    USB_BULK_OUT_ENDPOINT | (USB_OUT << USB_DESCRIPTOR_ENDPOINT_ADDRESS_DIRECTION_SHIFT);
                epInitStruct.maxPacketSize = HS_BULK_OUT_PACKET_SIZE;

                USB_DeviceInitEndpoint(usb_handle, &epInitStruct, &epCallback);

                /* Schedule buffer for receive */
                USB_DeviceRecvRequest(handle, USB_BULK_OUT_ENDPOINT, rx_packet.data, HS_BULK_OUT_PACKET_SIZE);
            }
            else
            {
                error = kStatus_USB_InvalidRequest;
            }
            break;
        }
        default:
            break;
    }

    return error;
}

/*!
 * @brief USB configure endpoint function.
 *
 * This function configure endpoint status.
 *
 * @param handle The USB device handle.
 * @param ep Endpoint address.
 * @param status A flag to indicate whether to stall the endpoint. 1: stall, 0: unstall.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
usb_status_t USB_DeviceConfigureEndpointStatus(usb_device_handle handle, uint8_t ep, uint8_t status)
{
    if (status)
    {
        return USB_DeviceStallEndpoint(handle, ep);
    }
    else
    {
        return USB_DeviceUnstallEndpoint(handle, ep);
    }
}

/*!
 * @brief Application initialization function.
 *
 * This function initializes the application.
 *
 * @return None.
 */
void APPInit(void)
{
    USB_DeviceClockInit();

    usb_handle = NULL;

    if (kStatus_USB_Success != USB_DeviceInit(USB_CONTROLLER_ID, USB_DeviceCallback, &usb_handle))
    {
        usb_echo("USB device setup failed\r\n");
        return;
    }

    USB_DeviceIsrEnable();

    USB_DeviceRun(usb_handle);
}

/*!
 * @brief Application task function.
 *
 * This function runs the task for application.
 *
 * @return None.
 */
void usb_send_packet(void)
{
    // Send IMU packet
    tx_packet.status++;
    USB_DeviceSendRequest(usb_handle, USB_BULK_IN_ENDPOINT, tx_packet.data, sizeof(tx_packet));
    return;
}

CameraI2C cameras[NUM_CAMERAS];
CameraGPIO camera_gpios[NUM_CAMERAS][GPIO_PER_CAM];
ICMIMU imu;

int main(void)
{
    POWER_SetBodVbatLevel(kPOWER_BodVbatLevel1650mv, kPOWER_BodHystLevel50mv, false);
    /* attach 12 MHz clock to FLEXCOMM0 (debug console) */
    CLOCK_AttachClk(BOARD_DEBUG_UART_CLK_ATTACH);

    GPIO_PortInit(GPIO, 1);
    GPIO_PortInit(GPIO, 0);

    BOARD_InitPins();
    BOARD_BootClockPLL150M();
    BOARD_InitDebugConsole();
    
    /* clocks to all the camera flexcomms */
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM1);
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM5);
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM3);
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM7);
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM2);
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM4);

    /* reset FLEXCOMM for I2C */
    RESET_PeripheralReset(kFC1_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kFC5_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kFC3_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kFC7_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kFC2_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kFC4_RST_SHIFT_RSTn);

    for (int cam_id = 0; cam_id < NUM_CAMERAS; ++cam_id)
    {
      camerai2c_init((I2C_Type *)(CAM_I2C_BASE[cam_id]), &cameras[cam_id]);
      for (int gpio_id = 0; gpio_id < GPIO_PER_CAM; ++gpio_id)
      {
        cameragpio_init(GPIO, &camera_gpios[cam_id][gpio_id], CAMGPIO_PORT, CAMGPIO_GPIOS[cam_id][gpio_id]);
      }
    }

    // nSHUTDOWN_REQ input
    gpio_pin_config_t shutdown_req_gpio_config = {
      .pinDirection = kGPIO_DigitalInput,
    };
    GPIO_PinInit(GPIO, nSHUTDOWN_REQ_PORT, nSHUTDOWN_REQ_GPIO, &shutdown_req_gpio_config);

    // nPW_EN output
    gpio_pin_config_t pw_en_gpio_config = {
      .pinDirection = kGPIO_DigitalOutput,
      .outputLogic = 0
    };
    GPIO_PinInit(GPIO, nPW_EN_PORT, nPW_EN_GPIO, &pw_en_gpio_config);

    // SPI BEGIN
    //CLOCK_AttachClk(kFRO12M_to_FLEXCOMM3);
    //RESET_PeripheralReset(kFC3_RST_SHIFT_RSTn);

    //icm42688_init(IMU_SPI, &imu);

    //uint8_t spi_tx[4] = {0x12, 0x34, 0x56, 0x78};
    //uint8_t spi_rx[4] = {0xEE, 0xEE, 0xEE, 0xEE};

    //imuspi_full_duplex(&imu, spi_tx, spi_rx, sizeof(spi_rx)); 
    // Hardware duplex, make sure rx is equal to tx
    //imuspi_transmit_data(&imu, spi_rx, sizeof(spi_rx));

    //imuspi_attach_interrupt(&imu.spi);
    // SPI END

    NVIC_ClearPendingIRQ(USB1_IRQn);
    NVIC_ClearPendingIRQ(USB1_NEEDCLK_IRQn);

    POWER_DisablePD(kPDRUNCFG_PD_USB1_PHY); /*< Turn on USB1 Phy */

    /* reset the IP to make sure it's in reset state. */
    RESET_PeripheralReset(kUSB1H_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kUSB1D_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kUSB1_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kUSB1RAM_RST_SHIFT_RSTn);

    CLOCK_EnableClock(kCLOCK_Usbh1);
    /* Put PHY powerdown under software control */
    *((uint32_t *)(USBHSH_BASE + 0x50)) = USBHSH_PORTMODE_SW_PDCOM_MASK;
    /* According to reference mannual, device mode setting has to be set by access usb host register */
    *((uint32_t *)(USBHSH_BASE + 0x50)) |= USBHSH_PORTMODE_DEV_ENABLE_MASK;
    /* enable usb1 host clock */
    CLOCK_DisableClock(kCLOCK_Usbh1);

    APPInit();
    tx_packet.status = 0;

    while (1)
    {
      /*
        if (imuspi_check_interrupt(&imu.spi))
        {
          icm42688_read_sensor_data(&imu, &tx_packet);
          //imuspi_full_duplex(&imu, spi_tx, spi_rx, sizeof(spi_rx)); 
          // TODO fill packet with imu data here
          tx_packet.packet_type = TX_PACKET_TYPE_IMU;
          usb_send_packet();
        }
        */
      // Service shutdown request
      if (GPIO_PinRead(GPIO, nSHUTDOWN_REQ_PORT, nSHUTDOWN_REQ_GPIO) == false)
      {
        // Pull up nPW_EN
        GPIO_PinWrite(GPIO, nPW_EN_PORT, nPW_EN_GPIO, true);
      }
      if (packet_received > 0)
      {
        switch (rx_packet.packet_type)
        {
          case RX_PACKET_TYPE_I2C_SEQUENTIAL:
          {
            // Series of blocking I2C calls
            camerai2c_regops_sequential(cameras, &rx_packet, &tx_packet);
            // Send result
            usb_send_packet();
            break;
          }
          case RX_PACKET_TYPE_I2C_SYNC:
          {
            // Series of non blocking I2C calls
            camerai2c_regops_sync(cameras, &rx_packet);
            usb_send_packet();
            break;
          }
          case RX_PACKET_TYPE_GPIO_CFG:
          {
            cameragpio_process_packet(camera_gpios, &rx_packet);
            // Send dummy packet
            usb_send_packet();

            break;
          }
        }
        tx_packet.status = rx_packet.status;
        --packet_received;
      }
    }
}
