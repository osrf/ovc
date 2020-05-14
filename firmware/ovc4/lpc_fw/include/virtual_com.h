/*
 * Copyright (c) 2015 - 2016, Freescale Semiconductor, Inc.
 * Copyright 2016 NXP
 * All rights reserved.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef _USB_CDC_VCOM_H_
#define _USB_CDC_VCOM_H_ 1

/*******************************************************************************
* Definitions
******************************************************************************/
#define CONTROLLER_ID kUSB_ControllerLpcIp3511Hs0
#define DATA_BUFF_SIZE HS_BULK_OUT_PACKET_SIZE

#define USB_DEVICE_INTERRUPT_PRIORITY (3U)

/* Define the types for application */
typedef struct _usb_cdc_vcom_struct
{
    usb_device_handle deviceHandle; /* USB device handle. */
} usb_cdc_vcom_struct_t;

#endif /* _USB_CDC_VCOM_H_ */
