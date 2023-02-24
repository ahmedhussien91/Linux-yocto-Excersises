# mount rootfs over network 

it is not practical at all to reflash the root filesystem on the target everytime a change is made. so we can set the root file system to be on the network.

to do so we follow the upcomming steps

### Configure Target

we need also to check linux kernel configuration for enabling the Network file system is enabled by using   

```sh 
bitbake -c menuconfig virtual/kernel
```

check that 

- `CONFIG_NFS_FS=y`, NFS client support

- `CONFIG_IP_PNP=y`, configure IP at boot time

- `CONFIG_ROOT_NFS=y`, support for NFS as rootfs

save and force rebuild of kernel then build image core-minimal-image again: 

```sh
bitbake -c savedefconfig virtual/kernel # savedefconfig
bitbake -f virtual/kernel # run the linux build again
bitbake core-image-minimal 
```



To configure this we need to set the bootloader to pass the kernel parameters to set RFS on network as follows, in our case of raspberrypi we will change "**cmdline.txt**" on the sdcard to this value

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

Root file system will be on the host machine on `/nfs`

# adding custom layer



# adding custom application



# Creating custom image



# Features

please refer to [yocto Features Documentation link](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-features.html): provides a reference of shipped machine and distro features you can include as part of your image, a reference on image features you can select, and a reference on feature backfilling.

## Introduction

Distributions can select which features they want to support through the `DISTRO_FEATURES` variable, usually appended in distribution configuration file, such as **poky.conf**

Machine features are set in the `MACHINE_FEATURES` variable, which is set in the machine configuration file and specifies the hardware features for a given machine.

These two variables combine to work out which **kernel modules**, **utilities**, and **other packages** to include. 

A given distribution can support a selected subset of features so some machine features might not be included if the distribution itself does not support them.

To determine see recipes that check if features exists or not to act on this value you can do

```sh
grep -r --exclude-dir=build*  'contains.*MACHINE_FEATURES.*' .
```

> ./poky/meta/recipes-kernel/linux/linux-yocto.inc:KERNEL_FEATURES_append = " ${@bb.utils.contains('MACHINE_FEATURES', 'numa', 'features/numa/numa.scc', '', d)}"
> ./poky/meta/recipes-extended/packagegroups/packagegroup-core-base-utils.bb:    ${@bb.utils.contains("MACHINE_FEATURES", "keyboard", "kbd", "", d)} \
> ./poky/meta/recipes-devtools/qemu/qemuwrapper-cross_1.0.bb:if [ ${@bb.utils.contains('MACHINE_FEATURES', 'qemu-usermode', 'True', 'False', d)} = False -a "${PN}" != "nativesdk-qemuwrapper-cross" ]; then
> ./poky/meta/recipes-devtools/python/python3_3.8.13.bb:    if bb.utils.contains('MACHINE_FEATURES', 'qemu-usermode', True, False, d) and d.getVar('BUILD_REPRODUCIBLE_BINARIES') != '1':
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "acpi", "packagegroup-base-acpi", "",d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "alsa", "packagegroup-base-alsa", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "apm", "packagegroup-base-apm", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "ext2", "packagegroup-base-ext2", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "vfat", "packagegroup-base-vfat", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "keyboard", "packagegroup-base-keyboard", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "pci", "packagegroup-base-pci", "",d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "pcmcia", "packagegroup-base-pcmcia", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "phone", "packagegroup-base-phone", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "serial", "packagegroup-base-serial", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "usbgadget", "packagegroup-base-usbgadget", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("MACHINE_FEATURES", "usbhost", "packagegroup-base-usbhost", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('MACHINE_FEATURES', 'apm', 'packagegroup-base-apm', '',d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('MACHINE_FEATURES', 'acpi', 'packagegroup-base-acpi', '',d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('MACHINE_FEATURES', 'keyboard', 'packagegroup-base-keyboard', '',d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('MACHINE_FEATURES', 'phone', 'packagegroup-base-phone', '',d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-core-boot.bb:SYSVINIT_SCRIPTS = "${@bb.utils.contains('MACHINE_FEATURES', 'rtc', '${VIRTUAL-RUNTIME_base-utils-hwclock}', '', d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-core-boot.bb:    ${@bb.utils.contains("MACHINE_FEATURES", "keyboard", "${VIRTUAL-RUNTIME_keymaps}", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-core-boot.bb:    ${@bb.utils.contains("MACHINE_FEATURES", "efi", "${EFI_PROVIDER} kernel", "", d)} \
> ./poky/meta/classes/gtk-doc.bbclass:                      bb.utils.contains('MACHINE_FEATURES', 'qemu-usermode', 'True', 'False', d), 'False', d)}"
> ./poky/meta/classes/manpages.bbclass:			if ${@bb.utils.contains('MACHINE_FEATURES', 'qemu-usermode', 'true','false', d)}; then
> ./poky/meta/classes/live-vm-common.bbclass:EFI = "${@bb.utils.contains("MACHINE_FEATURES", "efi", "1", "0", d)}"
> ./poky/meta/classes/live-vm-common.bbclass:EFI_CLASS = "${@bb.utils.contains("MACHINE_FEATURES", "efi", "${EFI_PROVIDER}", "", d)}"
> ./poky/meta/classes/live-vm-common.bbclass:    pcbios = bb.utils.contains("MACHINE_FEATURES", "pcbios", "1", "0", d)
> ./poky/meta/classes/live-vm-common.bbclass:        pcbios = bb.utils.contains("MACHINE_FEATURES", "efi", "0", "1", d)
> ./poky/meta/classes/gobject-introspection-data.bbclass:                      bb.utils.contains('MACHINE_FEATURES', 'qemu-usermode', 'True', 'False', d), 'False', d)}"
> ./poky/meta/recipes-sato/webkit/libwpe_1.4.0.1.bb:CFLAGS_append_rpi = " ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', '-D_GNU_SOURCE', d)}"
> ./poky/meta/recipes-sato/matchbox-panel-2/matchbox-panel-2_2.11.bb:DEPENDS += " ${@bb.utils.contains("MACHINE_FEATURES", "acpi", "libacpi", "",d)}"
> ./poky/meta/recipes-sato/matchbox-panel-2/matchbox-panel-2_2.11.bb:DEPENDS += " ${@bb.utils.contains("MACHINE_FEATURES", "apm", "apmd", "",d)}"
> ./poky/meta/recipes-sato/matchbox-panel-2/matchbox-panel-2_2.11.bb:EXTRA_OECONF += " ${@bb.utils.contains("MACHINE_FEATURES", "acpi", "--with-battery=acpi", "",d)}"
> ./poky/meta/recipes-sato/matchbox-panel-2/matchbox-panel-2_2.11.bb:EXTRA_OECONF += " ${@bb.utils.contains("MACHINE_FEATURES", "apm", "--with-battery=apm", "",d)}"
> ./poky/documentation/ref-manual/ref-features.rst:   $ git grep 'contains.*MACHINE_FEATURES.*feature'
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi.inc:KERNEL_MODULE_AUTOLOAD += "${@bb.utils.contains("MACHINE_FEATURES", "pitft28r", "stmpe-ts", "", d)}"
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi.inc:    VC4GRAPHICS="${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "1", "0", d)}"
> ./meta-raspberrypi/recipes-kernel/linux/linux-raspberrypi.inc:        PITFT="${@bb.utils.contains("MACHINE_FEATURES", "pitft", "1", "0", d)}"
> ./meta-raspberrypi/dynamic-layers/qt5-layer/recipes-qt/qt5/qtbase_%.bbappend:PACKAGECONFIG_GL_append_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', ' kms', '', d)}"
> ./meta-raspberrypi/dynamic-layers/qt5-layer/recipes-qt/qt5/qtbase_%.bbappend:OE_QTBASE_EGLFS_DEVICE_INTEGRATION_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'eglfs_brcm', d)}"
> ./meta-raspberrypi/dynamic-layers/qt5-layer/recipes-qt/qt5/qtbase_%.bbappend:RDEPENDS_${PN}_append_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' userland', d)}"
> ./meta-raspberrypi/dynamic-layers/qt5-layer/recipes-qt/qt5/qtbase_%.bbappend:DEPENDS_append_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' userland', d)}"
> ./meta-raspberrypi/recipes-graphics/kmscube/kmscube_%.bbappend:COMPATIBLE_HOST_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '(.*)', 'null', d)}"
> ./meta-raspberrypi/recipes-graphics/userland/userland_git.bb:PROVIDES += "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "", "virtual/libgles2 virtual/egl", d)}"
> ./meta-raspberrypi/recipes-graphics/userland/userland_git.bb:RPROVIDES_${PN} += "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "", "libgles2 egl libegl libegl1 libglesv2-2", d)}"
> ./meta-raspberrypi/recipes-graphics/userland/userland_git.bb:	if [ "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "1", "0", d)}" = "1" ]; then
> ./meta-raspberrypi/recipes-graphics/userland/userland_git.bb:RDEPENDS_${PN} += "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "libegl-mesa", "", d)}"
> ./meta-raspberrypi/recipes-graphics/mesa/mesa-demos_%.bbappend:COMPATIBLE_HOST_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '(.*)', 'null', d)}"
> ./meta-raspberrypi/recipes-graphics/cairo/cairo_%.bbappend:PACKAGECONFIG_append_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' egl ${PACKAGECONFIG_GLESV2}', d)}"
> ./meta-raspberrypi/recipes-graphics/xorg-xserver/xserver-xorg_%.bbappend:OPENGL_PKGCONFIGS_rpi = "dri glx ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'dri3 xshmfence glamor', '', d)}"
> ./meta-raspberrypi/recipes-graphics/xorg-xserver/xserver-xorg_%.bbappend:DEPENDS_append_rpi = " ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'userland', d)}"
> ./meta-raspberrypi/recipes-graphics/xorg-xserver/xserver-xf86-config_%.bbappend:    PITFT="${@bb.utils.contains("MACHINE_FEATURES", "pitft", "1", "0", d)}"
> ./meta-raspberrypi/recipes-graphics/wayland/weston_%.bbappend:PACKAGECONFIG_remove_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', 'fbdev', '', d)}"
> ./meta-raspberrypi/recipes-graphics/wayland/weston_%.bbappend:    ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' \
> ./meta-raspberrypi/recipes-graphics/wayland/wayland_%.bbappend:    if [ "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "1", "0", d)}" = "0" ]; then
> ./meta-raspberrypi/recipes-graphics/piglit/piglit_%.bbappend:RDEPENDS_${PN}_remove_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'mesa-demos', d)}"
> ./meta-raspberrypi/recipes-graphics/piglit/piglit_%.bbappend:COMPATIBLE_HOST_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '(.*)', 'null', d)}"
> ./meta-raspberrypi/recipes-graphics/libsdl2/libsdl2_%.bbappend:DEPENDS_append_rpi = " ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'userland', d)}"
> ./meta-raspberrypi/recipes-graphics/libva/libva_%.bbappend:DEPENDS_append_rpi = " ${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'userland', d)}"
> ./meta-raspberrypi/recipes-core/packagegroups/packagegroup-rpi-test.bb:OMXPLAYER  = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'omxplayer', d)}"
> ./meta-raspberrypi/recipes-core/packagegroups/packagegroup-core-tools-testapps.bbappend:X11GLTOOLS_remove_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'mesa-demos', d)}"
> ./meta-raspberrypi/classes/sdcard_image-rpi.bbclass:    ${@bb.utils.contains('MACHINE_FEATURES', 'armstub', 'armstubs:do_deploy', '' ,d)} \
> ./meta-raspberrypi/classes/sdcard_image-rpi.bbclass:    if [ "${@bb.utils.contains("MACHINE_FEATURES", "armstub", "1", "0", d)}" = "1" ]; then
> ./meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_%.bbappend:PACKAGECONFIG_append_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' dispmanx', d)}"
> ./meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_%.bbappend:DEPENDS_append_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', ' userland', d)}"
> ./meta-raspberrypi/recipes-multimedia/gstreamer/gstreamer1.0-plugins-base_%.bbappend:PACKAGECONFIG_GL_rpi = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '${PACKAGECONFIG_GL_VC4GRAPHICS}', 'egl gles2', d)}"
> ./meta-raspberrypi/recipes-multimedia/omxplayer/omxplayer_git.bb:SRC_URI_append = "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", " file://0001-Fix-build-with-vc4-driver.patch ", "", d)}"
> ./meta-raspberrypi/recipes-multimedia/omxplayer/omxplayer_git.bb:export INCLUDES = "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", " -D__GBM__", "", d)} \
> ./meta-raspberrypi/conf/machine/include/rpi-base.inc:    ${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "xserver-xorg-extension-glx", "", d)} \
> ./meta-raspberrypi/conf/machine/include/rpi-base.inc:    ${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "xf86-video-modesetting", "xf86-video-fbdev", d)} \
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/egl ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "userland", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libgles2 ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "userland", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libgl ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "mesa-gl", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/mesa ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "mesa-gl", d)}"
> ./meta-raspberrypi/conf/machine/include/rpi-default-providers.inc:PREFERRED_PROVIDER_virtual/libgbm ?= "${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "mesa", "mesa-gl", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:PITFT="${@bb.utils.contains("MACHINE_FEATURES", "pitft", "1", "0", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:PITFT22="${@bb.utils.contains("MACHINE_FEATURES", "pitft22", "1", "0", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:PITFT28r="${@bb.utils.contains("MACHINE_FEATURES", "pitft28r", "1", "0", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:PITFT28c="${@bb.utils.contains("MACHINE_FEATURES", "pitft28c", "1", "0", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:PITFT35r="${@bb.utils.contains("MACHINE_FEATURES", "pitft35r", "1", "0", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:VC4GRAPHICS="${@bb.utils.contains("MACHINE_FEATURES", "vc4graphics", "1", "0", d)}"
> ./meta-raspberrypi/recipes-bsp/bootfiles/rpi-config_git.bb:    if [ "${@bb.utils.contains("MACHINE_FEATURES", "armstub", "1", "0", d)}" = "1" ]; then

let's trace 'wifi' feature

```sh
grep -r --exclude-dir=build*  '.*contains.*MACHINE_FEATURES.*' .  | grep wifi # NO wifi as a machine feature
grep -r --exclude-dir=build*  '.*contains.*DISTRO_FEATURES.*' .  | grep wifi 
```

> ./poky/meta/recipes-core/systemd/systemd_244.5.bb:    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'rfkill', '', d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:            ${@bb.utils.contains("DISTRO_FEATURES", "wifi", "packagegroup-base-wifi", "", d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'kernel-module-hostap-cs', '',d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'kernel-module-orinoco-cs', '',d)} \
> ./poky/meta/recipes-core/packagegroups/packagegroup-base.bb:    ${@bb.utils.contains('DISTRO_FEATURES', 'wifi', 'kernel-module-spectrum-cs', '',d)}"
> ./poky/meta/recipes-core/busybox/busybox.inc:    busybox_cfg(bb.utils.contains_any('DISTRO_FEATURES', 'bluetooth wifi', True, False, d), 'CONFIG_RFKILL', cnf, rem)
> grep: ./poky/meta/recipes-connectivity/nfs-utils/.nfs-utils_2.4.3.bb.swp: binary file matches
> ./poky/meta/recipes-connectivity/neard/neard_0.16.bb:                     ${@bb.utils.contains('DISTRO_FEATURES', 'wifi','wpa-supplicant', '', d)} \
> grep: ./poky/meta/lib/oe/__pycache__/utils.cpython-310.pyc: binary file matches

**Note:** @bb.utils.contains('DISTRO_FEATURES', 'wifi', 'kernel-module-spectrum-cs', '',d) mean:

- `@` mean that the upcomming is a python code 
- `bb.utils.contains` it's definition is in `poky/bitbake/lib/bb/utils.py`
- function `contains`: `def contains(variable, checkvalues, truevalue, falsevalue, d)`
  - check if **checkvalues** is a subset of the variable string
  - return **truevalue** if true return **falsevalue** otherwise
  - **d** data store

  you will note that `packagegroup-base.bb` mentions the wifi multiple times let's explore this 

# optimizing your image

this is an answer to a stackoverflow question ([link](https://stackoverflow.com/questions/28765494/yocto-minimal-image-with-package-management)) 

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

 