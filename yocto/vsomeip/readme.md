# vsomeip project

This Document describe the steps you need to do to complete integration of [vsomeip](https://github.com/COVESA/vsomeip) open source stack in your image, and start developing your applications.

We will describe the following steps in this document:

1. we will start by creating an image by following steps in [1.building_Raspberrypi_image](https://github.com/ahmedhussien91/Linux-yocto-Excersises/blob/main/yocto/1.building_Raspberrypi_image/readme.md) --> [1](#1. build raspberrypi image)

2. Implement a custom layer (**meta-custom**) to include our applications --> [2](#2. custom layer)

3. write a recipe (**vsomeip_1.0.bb**) for compiling and integrating [vsomeip](https://github.com/COVESA/vsomeip) in our custom layer --> [3](#3. implement vsomeip recipe)

4. write our custom image (**vsomeip-image.bb**) and include components included in (**core-image-base**) + "openssh" + "vsomeip" --> [4]()

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

another thing to consider is that there may be some files that the bitbake won't identify to which package they are related. we use this syntax to tell the bitbake this information.
to include files to output packages we use:

```sh
FILES_${PN} += "" to append extra files to package
```

  

## 4. write our own image

[up](#vsomeip project)

we need now to create our image **vsomeip-image.bb** and base it on core-image-base

to base our image on **core-image-base** we use the word **require** as in the example

```sh
require recipes-core/images/core-image-base.bb
```

we will also have to install our **vsomeip** application + **openssh** application for that we will have to append those to the **IMAGE_INSTALL** variable



## 5. generate our image & SDK 

[up](#vsomeip project)

then we will bitbake our image and sdk using

```sh
bitbake vsomeip-image # create the image
bitbake vsomeip-image -c populate_sdk # generate the installer of the SDK in the tmp/deploy/sdk folder
# we will have to run the generated installer using the shell script inside tmp/deploy/sdk
```

we will have to run the generated installer using the shell script inside **tmp/deploy/sdk** 

then inside the SDK we will source the environment to setup the environment for our application compilation 

## 6. build our application



## 7. start the image and application 

## 8. run application on target 

