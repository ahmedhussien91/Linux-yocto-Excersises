# yocto

![image-20220916203154048](yocto_project_concepts.assets/image-20220916203154048.png)

# Bitbake

This link worth reading: [overview-manual-concepts](https://docs.yoctoproject.org/3.2.3/overview-manual/overview-manual-concepts.html)

## input meta-data components:

- ***Recipes**:* Provides details about particular pieces of software. (.**bb**, .**bbapend**, .**inc**)
- ***Class Data**:* Abstracts common build information (e.g. how to build a Linux kernel). (.**bbclass**)
- ***Configuration Data:*** Defines machine-specific settings, policy decisions, and so forth. Configuration data acts as the glue to bind everything together. (.**conf**)

### global configuration data set in local.conf

- *Target Machine Selection:* Controlled by the [MACHINE](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-MACHINE) variable.
- *Download Directory:* Controlled by the [DL_DIR](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-DL_DIR) variable.
- *Shared State Directory:* Controlled by the [SSTATE_DIR](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-SSTATE_DIR) variable.
- *Build Output:* Controlled by the [TMPDIR](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-TMPDIR) variable.
- *Distribution Policy:* Controlled by the [DISTRO](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-DISTRO) variable.
- *Packaging Format:* Controlled by the [PACKAGE_CLASSES](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-PACKAGE_CLASSES) variable.
- *SDK Target Architecture:* Controlled by the [SDKMACHINE](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-SDKMACHINE) variable.
- *Extra Image Packages:* Controlled by the [EXTRA_IMAGE_FEATURES](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-EXTRA_IMAGE_FEATURES) variable.

#### MACHINE and DISTRO

folder structure points to configuration that should be loaded from **.conf** data for example: 

- machine configuration is always found under  **meta/conf/machine**, when setting [MACHINE](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-MACHINE) to **qemux86** bitbake must find file **qemux86** under some meta-layer that includes **conf/machine** 
- same applies for distributions for variable [DISTRO](https://docs.yoctoproject.org/3.2.3/ref-manual/ref-variables.html#term-DISTRO) 



place all your layers layer under poky folder:

- if all layers are in the same folder you list all available **machines** through

  ```sh
  find . -path '*/conf/machine/*.conf'
  ```

  > ./meta/conf/machine/qemuppc.conf
  > ./meta/conf/machine/qemux86-64.conf
  > ./meta/conf/machine/qemuarmv5.conf
  > ./meta/conf/machine/qemux86.conf
  > ./meta/conf/machine/qemuriscv64.conf
  > ./meta/conf/machine/qemumips64.conf
  > ./meta/conf/machine/qemuarm64.conf
  > ./meta/conf/machine/qemuarm.conf
  > ./meta/conf/machine/qemumips.conf
  > ./meta-yocto-bsp/conf/machine/beaglebone-yocto.conf
  > ./meta-yocto-bsp/conf/machine/edgerouter.conf
  > ./meta-yocto-bsp/conf/machine/genericx86.conf
  > ./meta-yocto-bsp/conf/machine/genericx86-64.conf
  > ./meta-selftest/conf/machine/qemux86copy.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi4.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi-cm.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi4-64.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi-cm3.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi2.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi0-wifi.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi3.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi3-64.conf
  > ./meta-raspberrypi/conf/machine/raspberrypi0.conf

- you can also list all available distros through

  ```sh
  find . -path '*/conf/distro/*.conf'
  ```

  > ./meta-poky/conf/distro/poky-altcfg.conf
  > ./meta-poky/conf/distro/poky.conf
  > ./meta-poky/conf/distro/poky-bleeding.conf
  > ./meta-poky/conf/distro/poky-tiny.conf
  > ./meta/conf/distro/defaultsetup.conf

## Folder structure

![image-20220916190700872](yocto_project_concepts.assets/image-20220916190700872.png)

## General work flow 

![image-20220916203016058](yocto_project_concepts.assets/image-20220916203016058.png)



![image-20220918093801951](yocto_project_concepts.assets/image-20220918093801951.png)

![image-20220918093850507](yocto_project_concepts.assets/image-20220918093850507.png)
