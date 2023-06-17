#!/bin/bash
sudo qemu-system-arm -M vexpress-a9 -m 128M -nographic \
-kernel qemu/u-boot/u-boot \
-sd sd.img \
-net tap,script=./qemu-ifup -net nic