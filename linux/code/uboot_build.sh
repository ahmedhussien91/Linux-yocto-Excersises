#!/bin/bash
UBOOT_PATH="./$1/u-boot/"
CURRENT_PATH="$PWD"

if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    #qemu u-boot build
    if [ "$1" == "qemu" ]; then      
        cd $UBOOT_PATH
        source $CURRENT_PATH/setenv_crossCompiler.sh $1
        make vexpress_ca9x4_defconfig
        cp $CURRENT_PATH/qemu_vexpress_ca9x4_defconfig .config
        make 

        cd $CURRENT_PATH
    #beaglebone u-boot build
    else
        cd $UBOOT_PATH
        source $CURRENT_PATH/setenv_crossCompiler.sh $1
        make am335x_evm_defconfig
        make

        cd $CURRENT_PATH
    fi
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./uboot_build.sh <TARGET>
            Target: bb or qemu
            Ex. > ./uboot_build.sh bb"
fi
