#!/bin/bash

TARGET=$1

if [[ -z "$TARGET" ]]; then
    echo "Usage: $0 <TARGET>"
    exit 1
fi

echo "Building for target: $TARGET"
./download_dep.sh "$TARGET"
./ctng_BuildToolchain.sh "$TARGET"
./uboot_build.sh "$TARGET"
./linux_build.sh "$TARGET"
./busybox_build.sh "$TARGET"