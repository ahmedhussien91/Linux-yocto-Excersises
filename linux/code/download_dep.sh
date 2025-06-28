#!/bin/bash
# filepath: Linux-yocto-Excersises/linux/code/download_dep.sh

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    echo "Available targets:"
    awk '/^\[.*\]/{gsub(/\[|\]/,""); print "  - " $0}' targets.conf
    exit 1
fi

# Check if target exists in targets.conf
if ! grep -q "^\[$TARGET\]" targets.conf; then
    echo "Unknown target: $TARGET"
    echo "Valid targets are:"
    awk '/^\[.*\]/{gsub(/\[|\]/,""); print "  - " $0}' targets.conf
    exit 1
fi

# Source target-specific variables
source ./parse_config.sh "$TARGET"

echo "Downloading dependencies for target: $TARGET"

sudo apt-get update
sudo apt-get install -y build-essential git autoconf bison flex texinfo help2man gawk qemu-system-arm \
libtool-bin libncurses5-dev unzip libssl-dev libgmp3-dev libmpc-dev nfs-kernel-server tftpd-hpa libgnutls28-dev

mkdir -p "$TARGET"
cd "$TARGET" || exit 1

if [ ! -d crosstool-ng ]; then
    git clone https://github.com/crosstool-ng/crosstool-ng
    cd crosstool-ng/ || exit 1
    git checkout $CROSSTOOL_VER
    ./bootstrap
    ./configure --enable-local
    make
    cd ..
fi

if [ ! -d u-boot ]; then
    git clone https://github.com/u-boot/u-boot.git
    cd u-boot/ || exit 1
    git checkout $UBOOT_VER
    cd ..
fi

if [ ! -d linux ]; then
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
    cd linux || exit 1
    git checkout $LINUX_VER
    cd ..
fi

if [ ! -d busybox ]; then
    git clone git://git.busybox.net/busybox
    cd busybox || exit 1
    git checkout $BUSYBOX_VER
    cd ..
fi

