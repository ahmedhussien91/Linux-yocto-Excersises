#!/bin/bash
CTNG_PATH="./bb/crosstool-ng/"
CURRENT_PATH="$PWD"

cd $CTNG_PATH
./ct-ng arm-cortex_a8-linux-gnueabi
cp $CURRENT_PATH/bb_arm-cortex_a8-linux-gnueabi .config
./ct-ng source
./ct-ng build

