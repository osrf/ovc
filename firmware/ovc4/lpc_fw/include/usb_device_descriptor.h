/*
 * Copyright (c) 2015 - 2016, Freescale Semiconductor, Inc.
 * Copyright 2016 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef _USB_DEVICE_DESCRIPTOR_H_
#define _USB_DEVICE_DESCRIPTOR_H_ 1

/*******************************************************************************
* Definitions
******************************************************************************/
#define USB_DEVICE_SPECIFIC_BCD_VERSION (0x0200)
#define USB_DEVICE_DEMO_BCD_VERSION (0x0101U)

/* usb descriptor length */
#define USB_DESCRIPTOR_LENGTH_CONFIGURATION_ALL (sizeof(g_UsbDeviceConfigurationDescriptor))

/* Configuration, interface and endpoint. */
#define USB_DEVICE_CONFIGURATION_COUNT (1)
#define USB_DEVICE_STRING_COUNT (3)
#define USB_DEVICE_LANGUAGE_COUNT (1)

#define USB_CONFIGURE_INDEX (1)

#define USB_BULK_IN_ENDPOINT (1)
#define USB_BULK_OUT_ENDPOINT (1)
#define USB_INTERFACE_COUNT (1)
#define USB_DATA_INTERFACE_INDEX (0)

/* Packet size. */
#define HS_BULK_IN_PACKET_SIZE (512)
#define HS_BULK_OUT_PACKET_SIZE (512)

/* String descriptor length. */
#define USB_DESCRIPTOR_LENGTH_STRING0 (sizeof(g_UsbDeviceString0))
#define USB_DESCRIPTOR_LENGTH_STRING1 (sizeof(g_UsbDeviceString1))
#define USB_DESCRIPTOR_LENGTH_STRING2 (sizeof(g_UsbDeviceString2))

#define USB_DESCRIPTOR_TYPE_CDC_CS_INTERFACE (0x24)
#define USB_DESCRIPTOR_TYPE_CDC_CS_ENDPOINT (0x25)

#define USB_ENDPOINT_COUNT (2)

/* Class code. */
#define USB_DEVICE_CLASS (0x02)
#define USB_DEVICE_SUBCLASS (0x00)
#define USB_DEVICE_PROTOCOL (0x00)

#define USB_DEVICE_MAX_POWER (0x32)

// Vendor specific class
#define USB_CLASS (0xFF)
#define USB_SUBCLASS (0xFF)
#define USB_PROTOCOL (0xFF)

/*******************************************************************************
* API
******************************************************************************/
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
extern usb_status_t USB_DeviceCallback(usb_device_handle handle, uint32_t event, void *param);

/*!
 * @brief USB device set speed function.
 *
 * This function sets the speed of the USB device.
 *
 * Due to the difference of HS and FS descriptors, the device descriptors and configurations need to be updated to match
 * current speed.
 * As the default, the device descriptors and configurations are configured by using FS parameters for both EHCI and
 * KHCI.
 * When the EHCI is enabled, the application needs to call this function to update device by using current speed.
 * The updated information includes endpoint max packet size, endpoint interval, etc.
 *
 * @param handle The USB device handle.
 * @param speed Speed type. USB_SPEED_HIGH/USB_SPEED_FULL/USB_SPEED_LOW.
 *
 * @return A USB error code or kStatus_USB_Success.
 */
extern usb_status_t USB_DeviceSetSpeed(usb_device_handle handle, uint8_t speed);

#endif /* _USB_DEVICE_DESCRIPTOR_H_ */
