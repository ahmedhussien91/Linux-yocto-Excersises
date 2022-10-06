# vsomeip project

This Document describe the steps you need to do to complete integration of [vsomeip](https://github.com/COVESA/vsomeip) open source stack in your image, and start developing your applications.

We will describe the following steps in this document:

1. we will start by creating an image by following steps in [1.building_Raspberrypi_image](https://github.com/ahmedhussien91/Linux-yocto-Excersises/blob/main/yocto/1.building_Raspberrypi_image/readme.md) --> [1](#1. build raspberrypi image)

2. Implement a custom layer (**meta-custom**) to include our applications --> [2](#2. custom layer)

3. write a recipe (**vsomeip_1.0.bb**) for compiling and integrating [vsomeip](https://github.com/COVESA/vsomeip) in our custom layer --> [3](#3. implement vsomeip recipe)

4. write our custom image (**vsomeip-image.bb**) and include components included in (**core-image-base**) + "openssh" + "vsomeip"

5. bitbake new **vsomeip-image.bb** image and generate SDK

6. build applications of vsomeip using SDK

7. start new image and transfer the vsomeip applications to target using (**SCP**)

8. run applications on target ssh instances for each application 




## 1. build raspberrypi image

[up](#vsomeip project)

the output of this step is two folders and raspberrypi4 image:

- poky
- meta-raspberrypi
- core-image-base image

## 2. custom layer

[up](#vsomeip project)

you can create your custom layer by using the following commands:

```sh
bitbake-layers create-layer meta-custom # create a layer folder (meta-custom)
bitbake-layers add-layer meta-custom # add the meta-custom/ to $BUILDDIR/conf/bblayers.conf
bitbake-layers show-layers # show current layers, use it to confirm layers
```



## 3. implement vsomeip recipe

[up](#vsomeip project)

remember that all variables are **Strings**, use **${}** to export variables

remember that recipe **header** contains

```sh
DESCRIPTION= "" #describes what the software is about
HOMEPAGE= "" #URL to the project’s homepage
PRIORITY= "" #defaults to optional
SECTION= "" #package category (e.g. console/utils)
LICENSE="" #the application’s license,
```

Use **SRC_URI** to download the [vsomeip](https://github.com/COVESA/vsomeip) repository, remember for git we use 

```sh
git://<url>;protocol=<protocol>;branch=<branch>
```

Use **S** variable to modify the source code location, **WORKDIR** contain the location of work directory, for git source code is placed under **git** folder, so we will use something like that 

```sh
S="${WORKDIR}/git"
```

