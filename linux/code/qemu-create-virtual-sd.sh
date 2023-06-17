#!/bin/bash
dd if=/dev/zero of=sd.img bs=1M count=1024
if [ $? -ne 0 ]; then echo "Error: dd"; exit 1; fi

# Create 3 primary partitons on the sd.img file
#- one partition 64MB / FAT16 / bootable
#- one partition 96MB / linux / for root filesystem
#- one partition that fills the rest of the SD card image / linux /data file system 
# Create a 64MB FAT16 partition, bootable
sudo sfdisk sd.img << EOF
,64M,0x06,*
,96M,L,
,,L,
EOF
if [ $? -ne 0 ]; then echo "Error: sfdisk"; exit 1; fi


# setup loop device
loopDevName=$(sudo losetup -f --show --partscan sd.img) 
echo "loopdevice = $loopDevName"

sudo mkfs.vfat -F 16 -n boot ${loopDevName}p1
if [ $? -ne 0 ]; then echo "Error: mkfs.vfat partition 1"; exit 1; fi
sudo mkfs.ext4 ${loopDevName}p2
if [ $? -ne 0 ]; then echo "Error: mkfs.ext4 partition 2"; exit 1; fi
sudo mkfs.ext4 ${loopDevName}p3
if [ $? -ne 0 ]; then echo "Error: mkfs.ext4 partition 3"; exit 1; fi

mkdir -p sdcard/1
mkdir -p sdcard/2
mkdir -p sdcard/3

sudo mount ${loopDevName}p1 sdcard/1
sudo mount ${loopDevName}p2 sdcard/2
sudo mount ${loopDevName}p3 sdcard/3