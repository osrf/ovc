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
volatile bool packet_received = false;

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
    packet_received = true;
    usb_status_t error = kStatus_USB_Error;

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
void APP_task(void)
{
    // Send IMU packet
    tx_packet.header.status++;
    USB_DeviceSendRequest(usb_handle, USB_BULK_IN_ENDPOINT, tx_packet.data, sizeof(tx_packet));
    return;
}

CameraI2C cameras[6];
IMUSPI imu;

int main(void)
{
    /* attach 12 MHz clock to FLEXCOMM0 (debug console) */
    CLOCK_AttachClk(BOARD_DEBUG_UART_CLK_ATTACH);

    BOARD_InitPins();
    BOARD_BootClockPLL150M();
    BOARD_InitDebugConsole();

    // I2C BEGIN
    /* attach 12 MHz clock to FLEXCOMM8 (I2C master) */
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM4);
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM1);

    /* reset FLEXCOMM for I2C */
    RESET_PeripheralReset(kFC4_RST_SHIFT_RSTn);
    RESET_PeripheralReset(kFC1_RST_SHIFT_RSTn);
    camerai2c_init(CAM0_I2C, &cameras[0]);
    camerai2c_init(CAM1_I2C, &cameras[1]);
    camerai2c_configure_slave(&cameras[0], 0x12, 1);
    camerai2c_configure_slave(&cameras[1], 0x12, 1);
    uint32_t write_val = 0x56789ABC;
    // Write first
    camerai2c_setup_read(&cameras[0], 0x34, 4);
    camerai2c_setup_read(&cameras[1], 0x34, 4);
    camerai2c_wait_for_complete();
    // TODO more user friendly API without dangerous casts
    camerai2c_get_read_data(&cameras[0], (uint8_t *)&write_val);
    ++write_val;
    camerai2c_setup_write(&cameras[0], 0x34, write_val, sizeof(write_val));
    camerai2c_wait_for_complete();

    // I2C END
    // SPI BEGIN
    CLOCK_AttachClk(kFRO12M_to_FLEXCOMM3);
    RESET_PeripheralReset(kFC3_RST_SHIFT_RSTn);

    imuspi_init(IMU_SPI, &imu);

    uint8_t spi_tx[4] = {0x12, 0x34, 0x56, 0x78};
    uint8_t spi_rx[4] = {0xEE, 0xEE, 0xEE, 0xEE};

    imuspi_full_duplex(&imu, spi_tx, spi_rx, sizeof(spi_rx)); 
    // Hardware duplex, make sure rx is equal to tx
    imuspi_transmit_data(&imu, spi_rx, sizeof(spi_rx));

    imuspi_attach_interrupt(&imu);
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
    tx_packet.header.status = 0;

    while (1)
    {
        if (imuspi_check_interrupt(&imu))
        {
          imuspi_full_duplex(&imu, spi_tx, spi_rx, sizeof(spi_rx)); 
          APP_task();
        }
        if (packet_received)
        {
          tx_packet.header.status = rx_packet.header.status;
          packet_received = false;
        }
    }
}
