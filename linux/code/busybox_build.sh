#!/bin/bash

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    echo "Targets: bb, qemu, rpi4"
    exit 1
fi

CURRENT_PATH=$(pwd)
BUSYBOX_PATH="$CURRENT_PATH/$TARGET/busybox"

case "$TARGET" in
    bb|qemu|rpi4)
        source "$CURRENT_PATH/setenv_crossCompiler.sh" "$TARGET"
        cd "$BUSYBOX_PATH" || exit 1
        make 
        make -j$(nproc)
        make install
        ;;
    *)
        echo "Unknown target: $TARGET"
        exit 1
        ;;
esac

cd "$CURRENT_PATH" || exit 1
