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
# --$Create Date:2017/04/12 $
# --$Modify Date: 2018/05/25 $
# --$Version: 1.4 $
# --   check xilinx base install path
# --$Version: 1.3 $
# --   change Xilinx Setup files to support normal and SDX installation
# --$Version: 1.2 $
# --   export variables to be visible by Xilinx tools
# --------------------------------------------------------------------
# --------------------------------------------------------------------
function vivado_start {
  echo ----------------------Change to log folder--------------------------
  # vlog folder
  vlog_folder=${bashfile_path}/v_log
  echo ${vlog_folder}
  if ! [ -d "$vlog_folder" ]; then
     mkdir ${vlog_folder}
  fi 
  cd ${vlog_folder}
  # mkdir tmp
  # setenv XILINX_TCLSTORE_USERAREA tmp
  echo --------------------------------------------------------------------
  echo -------------------------Start VIVADO scripts -----------------------
  vivado -source ../scripts/script_main.tcl  -mode batch -notrace -tclargs --gui 1
  echo -------------------------scripts finished----------------------------
  echo --------------------------------------------------------------------
  echo --------------------Change to design folder-------------------------
  cd ..
  echo ------------------------Design finished-----------------------------
  exit
 }


echo ------------------------Set design paths----------------------------
# get paths
bashfile_name=${0##*/}
# bashfile_path=${0%/*}
bashfile_path=`pwd`
echo -- Run Design with: ${bashfile_name}
echo -- Use Design Path: ${bashfile_path}
echo ---------------------Load basic design settings---------------------
source $bashfile_path/design_basic_settings.sh
echo --------------------------------------------------------------------
echo ------------------Set Xilinx environment variables------------------
VIVADO_XSETTINGS=${XILDIR}/Vivado/${VIVADO_VERSION}/.settings64-Vivado.sh
SDK_XSETTINGS=${XILDIR}/SDK/${VIVADO_VERSION}/.settings64-SDK_Core_Tools.sh
LABTOOL_XSETTINGS=${XILDIR}/Vivado_Lab/${VIVADO_VERSION}/settings64.sh
if [ "${ENABLE_SDSOC}" == "" ]; then ENABLE_SDSOC=0; fi
if [ ${ENABLE_SDSOC} == 1 ]; then
  echo --Info: SDSOC use Vivado and SDK from SDx installation --
  echo --Info: SDSOC use Vivado and SDK from SDx installation --
  SDSOC_XSETTINGS=${XILDIR}/SDx/${VIVADO_VERSION}/settings64.sh
  VIVADO_XSETTINGS=${XILDIR}/Vivado/${VIVADO_VERSION}/settings64.sh
  SDK_XSETTINGS=${XILDIR}/SDK/${VIVADO_VERSION}/settings64.sh
fi
# # --------------------
if [ "${VIVADO_AVAILABLE}" == "" ]; then export VIVADO_AVAILABLE=0; fi
if [ "${SDK_AVAILABLE}" == "" ]; then export SDK_AVAILABLE=0; fi
if [ "${LABTOOL_AVAILABLE}" == "" ]; then export LABTOOL_AVAILABLE=0; fi
if [ "${SDSOC_AVAILABLE}" == "" ]; then export SDSOC_AVAILABLE=0; fi



# # --------------------
echo -- Use Xilinx Version: ${VIVADO_VERSION} --

if [ "${VIVADO_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx Vivado Settings --
  if !  [ -e "${VIVADO_XSETTINGS}" ]; then  
    echo -- Info: ${VIVADO_XSETTINGS} not found --
  else
    source ${VIVADO_XSETTINGS}
    export VIVADO_AVAILABLE=1
  fi
  VIVADO_XSETTINGS_ISDONE=1
fi

if [ "${SDK_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx SDK Settings --
  if !  [ -e "${SDK_XSETTINGS}" ]; then  
    echo -- Info: ${SDK_XSETTINGS} not found --
  else
    source ${SDK_XSETTINGS}
    export SDK_AVAILABLE=1
  fi
  SDK_XSETTINGS_ISDONE=1
fi

if [ "${LABTOOL_XSETTINGS_ISDONE}" == "" ]; then  echo --Info: Configure Xilinx LAbTools Settings --
  if !  [ -e "${LABTOOL_XSETTINGS}" ]; then  
    echo -- Info: ${LABTOOL_XSETTINGS} not found --
  else
    source ${LABTOOL_XSETTINGS}
    export LABTOOL_AVAILABLE=1
  fi
  LABTOOL_XSETTINGS_ISDONE=1
fi


if [ "${SDSOC_XSETTINGS_ISDONE}" == "" ] && [ ${ENABLE_SDSOC} == 1 ]; then  echo --Info: Configure Xilinx SDSoC Settings --
  if !  [ -e "${SDSOC_XSETTINGS}" ]; then  
    echo -- Info: ${SDSOC_XSETTINGS} not found --
  else
    source ${SDSOC_XSETTINGS}
    export SDSOC_AVAILABLE=1
  fi
  SDSOC_XSETTINGS_ISDONE=1
fi

echo --------------------------------------------------------------------
# check important settings
if [ ${VIVADO_AVAILABLE} == 1 ]; then
  vivado_start
else
  echo -- Error: Need Vivado to run. --
  if !  [ -e "${XILDIR}" ]; then  
    echo "-- Error: ${XILDIR} not found. Check path of XILDIR variable on design_basic_settings.sh (upper and lower case is important)"
  fi
  echo ---------------------------Error occurs-----------------------------
  echo --------------------------------------------------------------------
fi
