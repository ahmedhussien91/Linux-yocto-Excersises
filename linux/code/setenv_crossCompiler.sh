#!/bin/bash

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    echo "Targets: bb, qemu, rpi4"
    exit 1
fi

case "$TARGET" in
    bb)
        export ARCH=arm
        export CROSS_COMPILE="$HOME/x-tools/arm-cortex_a8-linux-gnueabihf/bin/arm-cortex_a8-linux-gnueabihf-"
        ;;
    qemu)
        export ARCH=arm
        export CROSS_COMPILE="$HOME/x-tools/arm-unknown-linux-gnueabi/bin/arm-unknown-linux-gnueabi-"
        ;;
    rpi4)
        export ARCH=arm64
        export CROSS_COMPILE="$HOME/x-tools/aarch64-rpi4-linux-gnu/bin/aarch64-rpi4-linux-gnu-"
        ;;
    *)
        echo "Unknown target: $TARGET"
        exit 1
        ;;
esac

echo "CROSS_COMPILE set to $CROSS_COMPILE"
echo "ARCH set to $ARCH"

