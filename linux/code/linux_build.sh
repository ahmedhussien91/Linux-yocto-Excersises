#!/bin/bash
LINUX_PATH="./$1/linux/"
CURRENT_PATH="$PWD"

if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    #qemu linux build
    if [ "$1" == "qemu" ]; then      
        cd $LINUX_PATH
        source $CURRENT_PATH/qemu-crossCompiler-setenv.sh
        make vexpress_defconfig
        make -j4 

        cd $CURRENT_PATH
    #beaglebone linux build
    else
        cd $LINUX_PATH
        source $CURRENT_PATH/beaglebone-crossCompiler-setenv.sh
        make mrproper #  Removes all intermediate files, including the .config file. Use this target to return the source tree to the state it was in immediately after cloning or extracting the source code.
        make multi_v7_defconfig
        make -j4 zImage
        make -j4 modules
        make dtbs

        cd $CURRENT_PATH
    fi
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./linux_build.sh <TARGET>
            Target: bb or qemu
            Ex. > ./linux_build.sh bb"
fi