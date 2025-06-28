#!/bin/bash

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    echo "Targets: bb, qemu, rpi4"
    exit 1
fi

CURRENT_PATH=$(pwd)
CTNG_PATH="$CURRENT_PATH/$TARGET/crosstool-ng"

case "$TARGET" in
    bb)
        cd "$CTNG_PATH" || exit 1
        ./ct-ng arm-cortex_a8-linux-gnueabihf
        cp $CURRENT_PATH/bb_arm-cortex_a8-linux-gnueabi .config
        ./ct-ng source
        ./ct-ng build
        ;;
    qemu)
        cd "$CTNG_PATH" || exit 1
        ./ct-ng arm-unknown-linux-gnueabi
        cp $CURRENT_PATH/qemu_arm-cortex_a8-linux-gnueabi .config
        ./ct-ng source
        ./ct-ng build
        ;;
    rpi4)
        cd "$CTNG_PATH" || exit 1
        ./ct-ng aarch64-rpi4-linux-gnu
        ./ct-ng source
        ./ct-ng build
        ;;
    *)
        echo "Unknown target: $TARGET"
        exit 1
        ;;
esac

cd "$CURRENT_PATH" || exit 1