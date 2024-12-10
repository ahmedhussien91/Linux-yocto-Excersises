#!/bin/bash
# versions
crosstool_ver="crosstool-ng-1.25.0"
linux_ver="v5.19.6"
busybox_ver="master"
uboot_ver="v2022.07"
TARGET=$1

sudo apt install build-essential git autoconf bison flex texinfo help2man gawk qemu-system-arm \
libtool-bin libncurses5-dev unzip libssl-dev libgmp3-dev libmpc-dev nfs-kernel-server tftpd-hpa libgnutls28-dev -y


download_dep () {
    mkdir $TARGET
    cd $TARGET
    git clone https://github.com/crosstool-ng/crosstool-ng
    cd crosstool-ng/
    git checkout $crosstool_ver
    ./bootstrap
    ./configure --enable-local
    make
    cd ..

    git clone https://github.com/u-boot/u-boot.git
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


if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $TARGET"
    if [ "$2" = "clean" ]; then
        clean
    fi
    download_dep
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./download_dep <TARGET> [clean]
            Target: bb or qemu
            Ex. > ./download_dep bb clean"
fi

