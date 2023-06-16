#!/bin/bash
sudo apt install build-essential git autoconf bison flex texinfo help2man gawk \
libtool-bin libncurses5-dev unzip libssl-dev libgmp3-dev libmpc-dev nfs-kernel-server tftpd-hpa

download_dep () {
    mkdir qemu
    cd qemu
    git clone https://github.com/crosstool-ng/crosstool-ng
    cd crosstool-ng/
    ./bootstrap
    ./configure --enable-local
    make
    cd  ..

    git clone https://github.com/u-boot/u-boot.git
    cd u-boot/
    git checkout v2022.07
    cd ..

    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
    cd linux
    git checkout v5.19.6
    cd ..
    git clone git://git.busybox.net/busybox
}

clean () {
    rm -fr qemu 
}

if [ "$1" = "clean" ]; then
    clean
fi
download_dep 
