#!/bin/bash

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    echo "Targets: bb, qemu, rpi4"
    exit 1
fi

CURRENT_PATH=$(pwd)
LINUX_PATH="$CURRENT_PATH/$TARGET/linux"

case "$TARGET" in
    bb)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" bb
        cd "$LINUX_PATH" || exit 1
        make mrproper #  Removes all intermediate files, including the .config file. Use this target to return the source tree to the state it was in immediately after cloning or extracting the source code.
        make multi_v7_defconfig
        make -j$(nproc) zImage modules dtbs
        ;;
    qemu)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" qemu
        cd "$LINUX_PATH" || exit 1
        make vexpress_defconfig
        make -j$(nproc) zImage modules dtbs
        ;;
    rpi4)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" rpi4
        cd "$LINUX_PATH" || exit 1
        make bcm2711_defconfig
        make -j$(nproc) Image modules dtbs
        ;;
    *)
        echo "Unknown target: $TARGET"
        exit 1
        ;;
esac

cd "$CURRENT_PATH" || exit 1
