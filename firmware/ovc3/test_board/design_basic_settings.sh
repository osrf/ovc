#! /bin/sh
# --------------------------------------------------------------------
# --   *****************************
# --   *   Trenz Electronic GmbH   *
# --   *   Holzweg 19A             *
# --   *   32257 Bünde   		      *
# --   *   Germany                 *
# --   *****************************
# --------------------------------------------------------------------
# --$Autor: Hartfiel, John $
# --$Email: j.hartfiel@trenz-electronic.de $
# --$Create Date:2017/01/24 $
# --$Modify Date: 2019/01/08 $
# --$Version: 1.3 $
# -- 1.3 Changes
# --    update 2018.3
# -- 1.2 Changes
# --    update 2018.2
# -- 1.2 Changes
# --    update 2017.4
# --    CVS Example
# --    Optional Xilinx environment for debugging
# --    lower cases for Xilinx default path
# -- 1.1 Changes
# --   export variables to be visible by Xilinx tools
# --------------------------------------------------------------------
# Additional description on: https://wiki.trenz-electronic.de/display/PD/Project+Delivery
# --------------------------------------------------------------------
# Important Settings:
# -------------------------
# --------------------
# Set Vivado Installation path:
#    -Attention: This scripts support only the predefined Vivado Version. Others Versions are not tested.
#    -Xilinx Software will be searched in:
#    -VIVADO (optional for project creation and programming): $XILDIR/Vivado/$VIVADO_VERSION/
#    -SDK (optional for software projects and programming): $XILDIR/SDK/$VIVADO_VERSION/
#    -LabTools (optional for programming only): $XILDIR/Vivado_Lab/$VIVADO_VERSION/
#    -SDSoC (optional used for SDSoC): $XILDIR/SDx/$VIVADO_VERSION/
#
# -Important Note: Check if Xilinx default install path use upper or lower case
export XILDIR=/opt/Xilinx
# -Attention: These scripts support only the predefined Vivado Version. 
export VIVADO_VERSION=2019.1
# --------------------
# Set Board part number of the project which should be created
#    -Available Numbers: (you can use ID,PRODID from TExxxx_board_file.csv list) or special name "LAST_ID" to get the board with the highest ID in the *.csv list
#    -Used for project creation and programming
#    -Example TE0726 Module : 
#      -USE ID           |USE PRODID                 
#      -@set PARTNUMBER=1|@set PARTNUMBER=<complete TE article name from the CSV list> 
export PARTNUMBER=23
# --------------------
# For program*file.cmd only:
#    -Select Software App, which should be configured.
#    -Use the folder name of the <projectname>/prebuilt/boot_image/<partname>/* subfolder. The *bin,*.mcs or *.bit from this folder will be used.
#    -If you will configure the raw *.bit or *.mcs from the <projectname>/prebuilt/hardware/<partname>/ folder, use @set SWAPP=NA or @set SWAPP="".
#    -Example: SWAPP=hello_world    --> used the file from prebuilt/boot_image/<partname>/hello_world
#              SWAPP=NA             --> used the file from <projectname>/prebuilt/boot_image/<partname>/
export SWAPP=NA
# --------------------
# For program*file.cmd only:
#    -If you want to program from the root-folder <projectname>, set @set PROGRAMM_ROOT_FOLDER_FILE=1, otherwise set @set PROGRAMM_ROOT_FOLDER_FILE=0
#    -Attention: it should be only one *.bit, *.msc or *.bin file in the root folder. 
export PROGRAM_ROOT_FOLDER_FILE=0
# --------------------
# # --------------------------------------------------------------------
# # Optional Settings:
# # -------------------------
# --------------------
# Do not close shell after processing
#  -Example: @set DO_NOT_CLOSE_SHELL=1, Shell will not be closed
#            @set DO_NOT_CLOSE_SHELL=0, Shell will be closed automatically
export DO_NOT_CLOSE_SHELL=0
# --------------------
# # Used only for zip functions (supported programs 7z.exe(7 zip) and zip.exe (Info ZIP) )
#    -Example: @set ZIP_PATH=/usr/bin/zip
#    -install zip with sudo apt-get install zip
export ZIP_PATH=`which zip`
# --------------------
# Enable SDSOC Setting (not set in every *.cmd file)
export ENABLE_SDSOC=0
# --------------------
# Xilinx GIT Hub Links:
# https://github.com/Xilinx/device-tree-xlnx
# https://github.com/Xilinx/u-boot-xlnx
# https://github.com/Xilinx/linux-xlnx
# Set Xilinx GIT Clone Path:
export XILINXGIT_DEVICETREE=/home/xilinx_git/device-tree-xlnx
# --------------------
# optional Xilinx Environment variables
# -- QSPI Uboot debug:
# export XIL_CSE_ZYNQ_DISPLAY_UBOOT_MESSAGES=1
# --------------------
