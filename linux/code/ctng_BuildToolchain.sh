#!/bin/bash
CTNG_PATH="./$1/crosstool-ng/"
CURRENT_PATH="$PWD"

if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    #qemu ctng build
    if [ "$1" == "qemu" ]; then      
        cd $CTNG_PATH
        ./ct-ng arm-cortexa9_neon-linux-gnueabihf
        ./ct-ng source
        ./ct-ng build
    #beaglebone ctng build
    else
        cd $CTNG_PATH
        ./ct-ng arm-cortex_a8-linux-gnueabi
        cp $CURRENT_PATH/bb_arm-cortex_a8-linux-gnueabi .config
        ./ct-ng source
        ./ct-ng build
    fi
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./ctng_BuildToolchain.sh <TARGET>
            Target: bb or qemu
            Ex. > ./ctng_BuildToolchain.sh bb"
fi