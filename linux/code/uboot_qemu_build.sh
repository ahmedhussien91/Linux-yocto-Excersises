#!/bin/bash
UBOOT_PATH="./qemu/uboot/"
CURRENT_PATH="$PWD"

cd $UBOOT_PATH
source $CURRENT_PATH/qemu-crossCompiler-setenv.sh
make vexpress_ca9x4_defconfig
cp $CURRENT_PATH/qemu_vexpress_ca9x4_defconfig .config
