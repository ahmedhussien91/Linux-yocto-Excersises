#!/bin/bash
BUSYBOX_PATH="./$1/busybox/"
CURRENT_PATH="$PWD"

if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    #qemu busybox build
    if [ "$1" == "qemu" ]; then      
        cd $BUSYBOX_PATH
        source $CURRENT_PATH/qemu-crossCompiler-setenv.sh
        make 
        make install # output is by default placed in _install/

        cd $CURRENT_PATH
    #beaglebone busybox build
    else
        cd $BUSYBOX_PATH
        source $CURRENT_PATH/beaglebone-crossCompiler-setenv.sh
        make 
        make install # output is by default placed in _install/

        cd $CURRENT_PATH
    fi
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./busybox_build.sh <TARGET>
            Target: bb or qemu
            Ex. > ./busybox_build.sh bb"
fi