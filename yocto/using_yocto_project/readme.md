# using Yocto project

## PREFERRED_PROVIDER

let's find out our PREFERRED_PROVIDER's in our Yocto project

```sh
grep -r PREFERRED_PROVIDER_virtual/.*= . 
```

> ...
>
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/kernel ?= "linux-raspberrypi"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/xserver ?= "xserver-xorg"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/egl ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "userland", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libgles2 ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "userland", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libgl ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "mesa-gl", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/mesa ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "mesa-gl", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libgbm ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "mesa-gl", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libomxil ?= "userland"

note that kernel used is the "linux-raspberrypi" package (recipe), let's find it 

```sh 
find . -name linux-raspberrypi*
```

> ...
>
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi.inc
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi_4.19.bb
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi_4.19.inc
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi_5.4.bb
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi-rt_4.19.bb
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi-rt_4.14.bb
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi_4.14.bb
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi_5.4.inc
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi-dev.bb

you can find its different packages "linux-raspberrypi" with different versions "4.19", "5.4", ...



let's find PREFERRED_VERSION of this package 

```sh
grep -r PREFERRED_VERSION_linux-raspberrypi .
```

> ...
>
> ./meta-raspberrypi/conf/machine/include/rpi-default-versions.inc:PREFERRED_VERSION_linux-raspberrypi ??= "5.4.%"

note selected version is "5.4"



## IMAGE_INSTALL

let's see our image `core-image-minimal`, search for files of the same name 

```sh
find . -name core-image-minimal*
```

> ...
>
> ./poky/meta/recipes-core/images/core-image-minimal-initramfs.bb
> ./poky/meta/recipes-core/images/core-image-minimal.bb
> ./poky/meta/recipes-core/images/core-image-minimal-mtdutils.bb
> ./poky/meta/recipes-core/images/core-image-minimal-dev.bb

take a look on `core-image-minimal.bb`

```sh
vim ./poky/meta/recipes-core/images/core-image-minimal.bb
```

> ... 
>
> IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"
>
> ...

this tells you that a `packagegroup-core-boot` will be added to image + `CORE_IMAGE_EXTRA_INSTALL` variable, 

let's search for CORE_IMAGE_EXTRA_INSTALL

```sh 
grep -r CORE_IMAGE_EXTRA_INSTALL .
```

> ...
>
> ./poky/build/tmp/deploy/images/raspberrypi2/core-image-minimal-raspberrypi2-20220910192322.testdata.json
>
> ...

let's view this file, I think this file contain all the variables of the yocto set after building **core-image-minimal**

### OVERRIDE

search for **OVERRIDE**: 

> "CLASSOVERRIDE": "class-target",
>
> "DISTROOVERRIDES": "poky",
>
> "FILESOVERRIDES": "arm:rpi:armv7ve:raspberrypi2:poky",
>
> "LIBCOVERRIDE": ":libc-glibc",
>
> "MACHINEOVERRIDES": "rpi:armv7ve:raspberrypi2",
>
> "OVERRIDES": "task-rootfs:linux-gnueabi:arm:pn-core-image-minimal:rpi:armv7ve:raspberrypi2:poky:class-target:libc-glibc:forcevariable",

note:

- OVERRIDE variable is composed of values from: CLASSOVERRIDE, DISTROOVERRIDES, LIBCOVERRIDE and MACHINEOVERRIDES

- variables that use the OVERRIDES, will apply the value with `_raspberrypi2` postfix for example

let's check some of those variables with `_raspberrypi2` postfix

```sh
grep -r .*_raspberrypi2.*= .
```

> ./poky/documentation/kernel-dev/kernel-dev-common.rst:   KBUILD_DEFCONFIG_raspberrypi2 ?= "bcm2709_defconfig"
> ./poky/documentation/ref-manual/ref-variables.rst:         KBUILD_DEFCONFIG_raspberrypi2 = "bcm2709_defconfig"
> ./meta-raspberrypi/classes/sdcard_image-rpi.bbclass:SDIMG_KERNELIMAGE_raspberrypi2 ?= "kernel7.img"
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi.inc:KBUILD_DEFCONFIG_raspberrypi2 ?= "bcm2709_defconfig"



who set the OVERRIDE variable ? 
```sh
grep -r OVERRIDE.*= . 2>/dev/null 
```

> ...
>
> ./meta-raspberrypi/conf/machine/raspberrypi4-64.conf:MACHINEOVERRIDES = "raspberrypi4:${MACHINE}"
> ./meta-raspberrypi/conf/machine/raspberrypi0.conf:MACHINEOVERRIDES = "raspberrypi:${MACHINE}"
> ./meta-raspberrypi/conf/machine/raspberrypi-cm.conf:MACHINEOVERRIDES = "raspberrypi:${MACHINE}"
> ./meta-raspberrypi/conf/machine/raspberrypi3-64.conf:MACHINEOVERRIDES = "raspberrypi3:${MACHINE}"

note that the machine is selected in the `local.conf` file, looks like the sequance go this way:

- your set the machine in local.conf
- each machine has a configuration 
-  MACHINEOVERRIDES is set in this machine configuration, like `raspberrypi3-64.conf`



### IMAGE_INSTALL

let's check the IMAGE_INSTALL in the .json file

```sh 
cat ./poky/build/tmp/deploy/images/raspberrypi2/core-image-minimal-raspberrypi2-20220910192322.testdata.json | grep IMAGE_INSTALL
```

> "IMAGE_INSTALL": "packagegroup-core-boot ", 

includes only the packages required to boot the linux system, let's add SSH support to the image by adding those lines to local.conf

```sh
IMAGE_INSTALL_append = "openssh"
```

then rebuild the image using 

```sh
bitbake core-image-minimal
dd if=poky/build/tmp/deploy/images/raspberrypi2/core-image-minimal-raspberrypi2.rpi-sdimg of=/dev/sdc
```



to configure ip your address you can use 

```sh
ifconfig <interfac-name> <ip-address>/<subnet> # ex. ifconfig enp0s3 192.168.178.32/24
```



## bitbake 

### Remember:

bitbake [target]

- -c \<task>: execute a given task

- -s: list all locally available recipes and their versions
- -f: force a given task to run by removing its stamp file
- World: keyword for all recipes
- -b \<recipe>: execute tasks from the given recipe (without resolving dependencies)

### play with bitbake:

list tasks of kernel `virtual/kernel`

```sh
bitbake -c listtasks virtual/kernel # executed the task listtasks :) which list all the tasks (added by default)
# do_<task>

# you can also configure the kernel by running `menuconfig` task
bitbake -c menuconfig virtual/kernel
```



openssh recipe was executed when we added it to image, try executing it again

```sh
bitbake openssh
```

> ...
>
> NOTE: Executing Tasks
> NOTE: Tasks Summary: Attempted 2069 tasks of which 2069 didn't need to be rerun and all succeeded.

try with `-f`

```sh 
bitbake -f openssh 
```



To see which kernel is used, dry-run BitBake:
```sh 
bitbake -vn virtual/kernel
```

> ...
>
> NOTE: selecting linux-raspberrypi to satisfy virtual/kernel due to PREFERRED_PROVIDERS



## Clean Sstate cache:

```sh
./poky/scripts/sstate-cache-management.sh --remove-duplicated -d --cache-dir=poky/build/sstate-cache/
```



# mount rootfs over network 
it is not practical at all to reflash the root filesystem on the target everytime a change is made. so we can set the RFS to be on the network.

### Configure Target

we need also to check linux kernel configuration for enabling the Network file system is enabled by using   

```sh 
bitbake -c menuconfig virtual/kernel
```

check that 

- `CONFIG_NFS_FS=y`, NFS client support

- `CONFIG_IP_PNP=y`, configure IP at boot time

- `CONFIG_ROOT_NFS=y`, support for NFS as rootfs

save and force rebuild of kernel then build image core-minimal-image again  

```sh
bitbake -c savedefconfig virtual/kernel //savedefconfig
bitbake -f virtual/kernel // run the linux build again
bitbake core-image-minimal 
```



To configure this we need to set the bootloader to pass the kernel parameters to set RFS on network as follows, in our case we will change "cmdline.txt" on the sdcard to this value

```sh
root=/dev/nfs rw console=tty1,115200 nfsroot=192.168.0.6:/nfs ip=192.168.0.100:::::eth0
```



### Configure Host

```sh
# Install an NFS server
sudo apt install nfs-kernel-server
# add exported directory to `/etc/exports` file, with target ip as follows
/nfs 192.168.0.100(rw,no_root_squash,no_subtree_check)
# ask you NFS server to apply this new configuration (reload this file)
sudo exportfs -r
```






# optimizing your image

I can suggest you few things, which may help you to optimize size of rootfs:

- Optimize as much as possible linux kernel binary and removed unnecessary packages (filesystem,device driver,networking etc).

  ```
  $ bitbake -c menuconfig virtual/kernel //configure as per your requirement
  $ bitbake -c savedefconfig virtual/kernel //savedefconfig
  $ bitbake -f virtual/kernel
  ```

- Configure Busybox and removed unused things:

  ```
  $ bitbake -c menuconfig busybox
  ```

- Remove those Distro features if not in use (and check more also): graphics [x11], sound [alsa], touchscreen [touchscreen], Multimedia. Change apply in `conf/local.conf` file. Example: `DISTRO_FEATURES_remove = "x11 alsa touchscreen bluetooth opengl wayland "`

- Choose proper system init manager: systemd or sysvinit

- Removed Unused Packages from the image. Example `PACKAGE_EXCLUDE = "perl5 sqlite3 udev-hwdb bluez3 bluez4"`

- For small embedded device preferred `PACKAGE_CLASSES = "package_ipk"` and it is well optimized for small systems.

 