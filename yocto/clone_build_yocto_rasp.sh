#!/bin/bash
#sudo apt update
sudo apt install -y \
  gawk \
  wget \
  git-core \
  diffstat \
  unzip \
  texinfo \
  gcc \
  build-essential \
  chrpath \
  socat \
  cpio \
  python3 \
  python3-pip \
  python3-pexpect \
  xz-utils \
  debianutils \
  iputils-ping \
  libsdl1.2-dev \
  xterm \
  curl \
  lz4 \
  zstd
#sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev

# Create a virtual environment
python3.11 -m venv yocto-venv
source yocto-venv/bin/activate

mkdir yocto_build
cd yocto_build
git clone git://git.yoctoproject.org/poky
cd poky
git checkout scarthgap
cd ..
git clone git://git.yoctoproject.org/meta-raspberrypi
cd meta-raspberrypi
git checkout scarthgap
cd ..
cd poky
source oe-init-build-env 
bitbake-layers add-layer ../../meta-raspberrypi/
bitbake-layers add-layer ../../meta-openembedded/meta-*
bitbake-layers show-layers
echo "MACHINE = \"raspberrypi4-64\"" >> conf/local.conf 
echo "IMAGE_FSTYPES = \"tar.xz ext3 rpi-sdimg\"" >> conf/local.conf 
echo "LICENSE_FLAGS_ACCEPTED += \"synaptics-killswitch\"" >> conf/local.conf
cat conf/local.conf  
cd .. 
bitbake rpi-test-image 

