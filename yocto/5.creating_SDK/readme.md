# SDK types

Two different SDKs can be generated:

- A **generic SDK**, including:
  - A toolchain.
  - Common tools.
  - A collection of basic libraries.

- An **image-based SDK**, including:
  - The generic SDK.
  - The sysroot matching the target root filesystem.
  - Its toolchain is self-contained (linked to an SDK embedded libc).

- An image-based **extensible SDK** include but it's content can be minimized using variables:

  - A toolchain.

  - Common tools.

  - A collection of basic libraries.

  - The sysroot matching the target root filesystem.

  - **devtool** support

  - Example of Variables used

    ```sh
    SDK_EXT_TYPE = "minimal" # full or minimal(don't contain toolchain but with variables)
    SDK_INCLUDE_TOOLCHAIN = "1" #  the full SDK will by default include the toolchain, and the minimal SDK will not, unless configured to do so.
    SDK_INCLUDE_PKGDATA = "1" #  includes the package data for all world target recipes in the extensible SDK, this increase build time, but allow devtool to access all packages
    ```

    
  


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

to setup this SDK on machine we should run this script

```sh
./sysd-poky-glibc-x86_64-custom-image-armv7at2hf-neon-beaglebone-toolchain-3.1.24.sh
```

>  Poky (Yocto Project Reference Distro) SDK installer version 3.1.24
>
> Enter target directory for SDK (default: /opt/sysd-poky/3.1.24): 
> You are about to install the SDK to "/opt/sysd-poky/3.1.24". Proceed [Y/n]? y
> [sudo] password for ahmed: 
> Extracting SDK.........................................................................................done
> Setting it up...done
> SDK has been successfully set up and is ready to be used.
> Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
>  $ . /opt/sysd-poky/3.1.24/environment-setup-armv7at2hf-neon-poky-linux-gnueabi

to use we source this script 

```sh
. /opt/sysd-poky/3.1.24/environment-setup-armv7at2hf-neon-poky-linux-gnueabi
```



# Steps to Create extensible SDK

```sh
bitbake -c populate_sdk_ext custom-image
```

output is in `$BUILDDIR/tmp/deploy/sdk`

to setup this SDK on machine we should run this script

```sh
./sysd-poky-glibc-x86_64-custom-image-armv7at2hf-neon-beaglebone-toolchain-ext-3.1.23.sh
```

> Poky (Yocto Project Reference Distro) Extensible SDK installer version 3.1.23
>
> Enter target directory for SDK (default: ~/sysd-poky_sdk): 
> You are about to install the SDK to "/home/ahmed/sysd-poky_sdk". Proceed [Y/n]? y
> Extracting SDK......................................................done
> Setting it up...
> Extracting buildtools...
> Preparing build system...
> Parsing recipes: 100% |######################################################################################################| Time: 0:01:47
> Initialising tasks: 100% |###################################################################################################| Time: 0:00:05
> Checking sstate mirror object availability: 100% |###########################################################################| Time: 0:00:01
> Loading cache: 100% |########################################################################################################| Time: 0:00:01
> Initialising tasks: 100% |###################################################################################################| Time: 0:00:01
> done
> SDK has been successfully set up and is ready to be used.
> Each time you wish to use the SDK in a new shell session, you need to source the environment setup script e.g.
>  $ . /home/ahmed/sysd-poky_sdk/environment-setup-armv7at2hf-neon-poky-linux-gnueabi

to use we source this script 

```sh
. /home/ahmed/sysd-poky_sdk/environment-setup-armv7at2hf-neon-poky-linux-gnueabi
```



# using this SDK to build the application

### Steps to build application:

#### Install SDK

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





