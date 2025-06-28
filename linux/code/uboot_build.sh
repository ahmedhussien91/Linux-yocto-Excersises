#!/bin/bash

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    echo "Targets: bb, qemu, rpi4"
    exit 1
fi

CURRENT_PATH=$(pwd)
UBOOT_PATH="$CURRENT_PATH/$TARGET/u-boot"

case "$TARGET" in
    bb)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" bb
        cd "$UBOOT_PATH" || exit 1
        make am335x_evm_defconfig
        make -j$(nproc)
        ;;
    qemu)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" qemu
        cd "$UBOOT_PATH" || exit 1
        make vexpress_ca9x4_defconfig
        make -j$(nproc)
        ;;
    rpi4)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" rpi4
        cd "$UBOOT_PATH" || exit 1
        make $CURRENT_PATH/rpi_4_mmc_1_2_defconfig
        mkimage -C none -A arm -T script -d $CURRENT_PATH/rpi4_boot.cmd boot.scr
        make -j$(nproc)
        ;;
    *)
        echo "Unknown target: $TARGET"
        exit 1
        ;;
esac

cd "$CURRENT_PATH" || exit 1
