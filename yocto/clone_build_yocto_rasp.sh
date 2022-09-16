#!/bin/bash
sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool
git clone git://git.yoctoproject.org/poky
cd poky
git checkout dunfell
cd ..
git clone git://git.yoctoproject.org/meta-raspberrypi
cd meta-raspberrypi
git checkout dunfell
cd ..
cd poky
source oe-init-build-env 
bitbake-layers add-layer ../../meta-raspberrypi/
bitbake-layers add-layer ../../meta-openembedded/meta-*
bitbake-layers show-layers
echo "MACHINE = \"raspberrypi2\"" >> conf/local.conf 
echo "IMAGE_FSTYPES = \"tar.xz ext3 rpi-sdimg\"" >> conf/local.conf 
cat conf/local.conf  
cd .. 
bitbake rpi-hwup-image 
