
#!/bin/bash

if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    #qemu busybox build
    if [ "$1" == "qemu" ]; then      
        PATH=${HOME}/x-tools/arm-cortexa9_neon-linux-gnueabihf/bin/:$PATH
        export CROSS_COMPILE=arm-cortexa9_neon-linux-gnueabihf-
        export ARCH=arm

    #beaglebone busybox build
    else
        PATH=${HOME}/x-tools/arm-cortex_a8-linux-gnueabihf/bin/:$PATH
        export CROSS_COMPILE=arm-cortex_a8-linux-gnueabihf-
        export ARCH=arm
    fi
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./setenv_crossCompiler.sh <TARGET>
            Target: bb or qemu
            Ex. > ./setenv_crossCompiler.sh bb"
fi

