# building Qt application 

### perquisites 

```sh
sudo apt-get install gawk curl git-core git-lfs diffstat unzip texinfo build-essential \
chrpath libsdl1.2-dev xterm gperf bison gcc-multilib g++-multilib repo
```





# working with qt6

you can build your custom linux image to use qt using yocto

what we are doing is following this [link](https://doc.qt.io/Boot2Qt-5.15/qtee-custom-embedded-linux-image.html)

### perquisites 

```sh
sudo apt-get install gawk curl git-core git-lfs diffstat unzip texinfo build-essential \
chrpath libsdl1.2-dev xterm gperf bison gcc-multilib g++-multilib repo
```

download the layers of needed by qt by using **[repo](https://gerrit.googlesource.com/git-repo/+/master/docs/manifest-format.md)**, selecting name of the manifest to use from [here](https://code.qt.io/cgit/yocto/boot2qt-manifest.git/tree/)

```sh
mkdir build
cd build
repo init -u git://code.qt.io/yocto/boot2qt-manifest -m v6.2.6-lts.xml # we got the manifist name from https://code.qt.io/cgit/yocto/boot2qt-manifest.git/tree/ 
repo sync
```

you will have 

**setup-environment.sh:** script that you will use to 

- select **bblayer.conf** configuration from **source/templates** according to **MACHINE** variable

- create the **build** folder with selected **bblayer.conf** + **local.conf** from **/sources/meta-boot2qt/meta-boot2qt-distro/conf/local.conf.sample**  

- then setup the environment to use **bitbake** by calling **source oe-...** from **sources/poky** folder,

  

**sources/:** you will find the yocto layers needed to build a linux image with qt-applications support 

layers used in **sources/**:

- **bsp layers** (meta-toradex-bsp-common, meta-freescale, meta-intel, meta-raspberrypi,  meta-toradex-nxp, meta-freescale-3rdparty,  meta-tegra )

- **qt layers** (meta-boot2qt/meta-boot2qt, meta-boot2qt/**meta-boot2qt-distro**, meta-qt6)

- **other layers** (meta-mingw, meta-openembedded/*, poky)  

- **templates** (folder that contain sample configuration for different machines and for **b2qt** distro configuration) like **bblayers.conf** for **rpi** machine 

  ```
  ############################################################################
  ##
  ## Copyright (C) 2016 The Qt Company Ltd.
  ## Contact: https://www.qt.io/licensing/
  ##
  ## This file is part of the Boot to Qt meta layer.
  ##
  ## $QT_BEGIN_LICENSE:GPL$
  ## Commercial License Usage
  ## Licensees holding valid commercial Qt licenses may use this file in
  ## accordance with the commercial license agreement provided with the
  ## Software or, alternatively, in accordance with the terms contained in
  ## a written agreement between you and The Qt Company. For licensing terms
  ## and conditions see https://www.qt.io/terms-conditions. For further
  ## information use the contact form at https://www.qt.io/contact-us.
  ##
  ## GNU General Public License Usage
  ## Alternatively, this file may be used under the terms of the GNU
  ## General Public License version 3 or (at your option) any later version
  ## approved by the KDE Free Qt Foundation. The licenses are as published by
  ## the Free Software Foundation and appearing in the file LICENSE.GPL3
  ## included in the packaging of this file. Please review the following
  ## information to ensure the GNU General Public License requirements will
  ## be met: https://www.gnu.org/licenses/gpl-3.0.html.
  ##
  ## $QT_END_LICENSE$
  ##
  ############################################################################
  
  # POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
  # changes incompatibly
  POKY_BBLAYERS_CONF_VERSION = "2"
  
  BBPATH = "${TOPDIR}"
  BBFILES ?= ""
  BSPDIR := "${@os.path.abspath(os.path.dirname(d.getVar('FILE')) + '/../..')}"
  
  BBLAYERS ?= " \
    ${BSPDIR}/sources/poky/meta \
    ${BSPDIR}/sources/poky/meta-poky \
    ${BSPDIR}/sources/meta-raspberrypi \
    ${BSPDIR}/sources/meta-openembedded/meta-oe \
    ${BSPDIR}/sources/meta-openembedded/meta-python \
    ${BSPDIR}/sources/meta-openembedded/meta-networking \
    ${BSPDIR}/sources/meta-openembedded/meta-initramfs \
    ${BSPDIR}/sources/meta-openembedded/meta-multimedia \
    ${BSPDIR}/sources/meta-boot2qt/meta-boot2qt \
    ${BSPDIR}/sources/meta-boot2qt/meta-boot2qt-distro \
    ${BSPDIR}/sources/meta-mingw \
    ${BSPDIR}/sources/meta-qt6 \
    "
  ~                       
  ```

  ## building the Image and Toolchain

  to build the image we define the MACHINE and call setup-environment.sh script

  ```sh
  export MACHINE=raspberrypi4 
  source ./setup-environment.sh
  ```

  > You had no conf/local.conf file. This configuration file has therefore been
  > created for you with some default values. You may wish to edit it to, for
  > example, select a different MACHINE (target hardware). See conf/local.conf
  > for more information as common configuration options are commented.
  >
  > The Yocto Project has extensive documentation about OE including a reference
  > manual which can be found at:
  >     https://docs.yoctoproject.org
  >
  > For more information about OpenEmbedded see the website:
  >     https://www.openembedded.org/
  >
  >
  > ### Shell environment set up for builds. ###
  >
  > You can now run 'bitbake <target>'
  >
  > Common targets are:
  >     b2qt-embedded-qt6-image
  >     meta-toolchain-b2qt-embedded-qt6-sdk
  >
  > QBSP target is:
  >     meta-b2qt-embedded-qbsp
  >
  > For creating toolchain or QBSP for Windows, set environment variable before running bitbake:
  >     SDKMACHINE=x86_64-mingw32
  >
  > For more information about Boot to Qt, see https://doc.qt.io/QtForDeviceCreation/

  **build-raspberrypi4** folder was created with **conf/bblayers.conf** and **conf/local.conf** inside it 

then we build using 

```sh
bitbake b2qt-embedded-qt6-image # to build the application, failed to build bt2qt layer is a `commercial` layer
bitbake meta-toolchain-b2qt-embedded-qt6-sdk # to build the SDK
```



[**NOT COMPLETE**]
