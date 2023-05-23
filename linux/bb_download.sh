#!/bin/bash
# versions
crosstool_ver="crosstool-ng-1.22.0"
linux_ver="v5.19.6"
busybox_ver="master"
uboot_ver="v2022.07"


sudo apt install build-essential git autoconf bison flex texinfo help2man gawk \
libtool-bin libncurses5-dev unzip libssl-dev libgmp3-dev libmpc-dev nfs-kernel-server tftpd-hpa


download_dep () {
    mkdir bb
    cd bb
    git clone https://github.com/crosstool-ng/crosstool-ng
    cd crosstool-ng/
    git checkout $crosstool_ver
    ./bootstrap
    ./configure --enable-local
    make
    cd ..

    git clone git@github.com:u-boot/u-boot.git
    cd u-boot/
    git checkout $uboot_ver
    cd ..

    
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
    cd linux
    git checkout $linux_ver
    cd ..

    git clone git://git.busybox.net/busybox
    cd busybox
    git checkout $busybox_ver
    cd ..
}

clean () {
    rm -fr bb 
}

if [ "$1" = "clean" ]; then
    clean
fi
download_dep