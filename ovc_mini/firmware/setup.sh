#!/bin/bash

# Thank you to https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
export OVC_MINI_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
UTILS=$OVC_MINI_DIR/utils
BSP=$OVC_MINI_DIR/bsp

# Adds the argument to the path if not already in path.
add_to_path () {
  [[ ":$PATH:" != *":$1:"* ]] && PATH="$1:${PATH}"
}

install_utils () {
  cd $UTILS

  if [ ! -z "$UTILS/repo" ]; then
    # Download the repo script.
    curl https://storage.googleapis.com/git-repo-downloads/repo > $UTILS/repo
    chmod a+rx $UTILS/repo
  fi

  # Download and build nxp mfgtools (along with dependencies).
  if [ ! -d "$UTILS/mfgtools" ]; then
    git clone https://github.com/NXPmicro/mfgtools.git mfgtools
    cd mfgtools
    sudo apt-get install libusb-1.0-0-dev libzip-dev libbz2-dev pkg-config cmake libssl-dev g++
    mkdir build && cd "$_"
    cmake .. && make

    echo "Installing udev rules for uuu."
    sudo sh -c "sudo $UTILS/mfgtools/build/uuu/uuu -udev >> /etc/udev/rules.d/70-uuu.rules"
    sudo udevadm control --reload
  fi

  cd $OVC_MINI_DIR
}

install_bsp () {
  mkdir $BSP && cd "$_"
  repo init -u https://github.com/gbalke/ovc-mini-bsp -b hardknott
  repo sync
  cd $OVC_MINI_DIR
}

# Download/install utils.
install_utils  

# Install karo-bsp if not already downloaded.
if [ ! -d "$BSP" ]; then
  install_bsp
fi

# Add utils to the path.
add_to_path $OVC_MINI_DIR/utils
add_to_path $OVC_MINI_DIR/utils/mfgtools/build/uuu
