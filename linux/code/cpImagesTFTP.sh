#!/bin/bash
LINUX_PATH="./$1/linux/"
CURRENT_PATH="$PWD"

if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    #cp dtb and linux image to /srv/tftp
    cp $LINUX_PATH/arch/arm/boot/dts/vexpress-v2p-ca9.dtb /srv/tftp/
    cp $LINUX_PATH/arch/arm/boot/zImage /srv/tftp/zImage_$1
else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./cpImagesTFTP.sh <TARGET>
            Target: bb or qemu
            Ex. > ./cpImagesTFTP.sh bb"
fi