#!/bin/bash
UBOOT_PATH="./bb/uboot/"
CURRENT_PATH="$PWD"

cd $UBOOT_PATH
source $CURRENT_PATH/beaglebone-crossCompiler-setenv.sh
make am335x_evm_defconfig
make