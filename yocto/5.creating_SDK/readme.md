# SDK types

Two different SDKs can be generated:

- A generic SDK, including:
  - A toolchain.
  - Common tools.
  - A collection of basic libraries.
-  An image-based SDK, including:
  - The generic SDK.
  - The sysroot matching the target root filesystem.
  - Its toolchain is self-contained (linked to an SDK embedded libc).

# steps to create generic SDK 

```sh
bitbake meta-toolchain
```

output is in `$BUILDDIR/tmp/deploy/sdk`

# Steps to create image-based SDK

```sh
bitbake -c populate_sdk custom-image
```

output is in `$BUILDDIR/tmp/deploy/sdk`







# using this SDK to build the application

### Steps to build application:

#### install SDK

Ex. for **meta-toolchain**

```sh
./poky-glibc-x86_64-custom-image-armv7at2hf-neon-beaglebone-toolchain-3.1.23.sh
```

for **custom-image**

```sh
./poky-glibc-x86_64-custom-image-cortexa7t2hf-neon-vfpv4-raspberrypi4-toolchain-3.1.23.sh
```

#### setup SDK environment and build the application

source the script for **custom-image** and build the **readApp**, from `posix-app` folder

```sh
. /opt/poky/3.1.23/environment-setup-armv7at2hf-neon-poky-linux-gnueabi
./build.sh
```

we can check the output binary using **file** command

```sh
file build/read-app/readapp
```

> build/read-app/readapp: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, BuildID[sha1]=53aaed094c24077819122ea8c0b4806cd0b27874, for GNU/Linux 3.2.0, with debug_info, not stripped

