# vsomeip project

This Document describe the steps you need to do to complete integration of [vsomeip](https://github.com/COVESA/vsomeip) open source stack in your image, and start developing your applications.

We will describe the following steps in this document:

1. we will start by creating an image by following steps in [1.building_Raspberrypi_image](https://github.com/ahmedhussien91/Linux-yocto-Excersises/blob/main/yocto/1.building_Raspberrypi_image/readme.md)  but for MACHINE="**beaglebone-yocto**"--> [1](#1. build raspberrypi image)
2. Implement a custom layer (**meta-custom**) to include our applications --> [2](#2. custom layer)
3. write a recipe (**vsomeip_1.0.bb**) for compiling and integrating [vsomeip](https://github.com/COVESA/vsomeip) in our custom layer --> [3](#3. implement vsomeip recipe)
4. write our custom image (**vsomeip-image.bb**) and include components included in (**core-image-base**) + "openssh" + "vsomeip" --> [4]()
5. bitbake new **vsomeip-image.bb** image and generate SDK.
6. build **[applications](https://github.com/ahmedhussien91/Linux-yocto-Excersises/tree/main/yocto/vsomeip/applications_code)** of vsomeip using SDK and test on **qemu** of **beaglebone-yocto**.
7. Implement recipe for each application **vsomeip-server_1.0.bb** & **vsomeip-client_1.0.bb**, make sure that the application start automatically using **systemV** or **systemd**.
8. Include applications in   **vsomeip-image.bb** and rebuild.
9. start new image with **vsomeip** applications and see them running in the background using `ps -aux` command

<p style="color:red;">NOTE: to be submitted a  short video with the steps</p>




## 1. build raspberrypi image

[up](#vsomeip project)

the output of this step is **poky** folder and **beaglebone-yocto** image



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
#DESCRIPTION #describes what the software is about
#HOMEPAGE #URL to the project’s homepage
#PRIORITY #defaults to optional
#SECTION #package category (e.g. console/utils)
#LICENSE #the application’s license,
# you can use 
DESCRIPTION= "vsomeip libraries recipe"
LICENSE="CLOSED"
```

Use **SRC_URI** to download the [vsomeip](https://github.com/COVESA/vsomeip) repository, remember for git we use 

```sh
# git://<url>;protocol=<protocol>;branch=<branch>
SRC_URI = "git://github.com/COVESA/vsomeip.git;protcol=https;branch=master"
```

also our library depends on the **boost** library to build you can specify this in the library using variable **DEPENDS**

```sh
DEPENDS ="boost"
```

Use **S** variable to point to the source code location, remember that **WORKDIR** contain the location of work directory for this application(vsomeip), for git source code is placed under **git** folder, so we point to this folder using  

```sh
S="${WORKDIR}/git"
```

our application builds using **cmake**, tasks to build cmake is already implemented in **cmake.bbclass** so we can use to include this in our recipe 

```sh
inherit cmake 
```

another thing to consider is that there may be some files that the bitbake won't identify to which package they are related. we use this syntax to tell the bitbake this information.
to include files to output packages we use:

```sh
# FILES_${PN} += "" to append extra files to package
# we can use 
FILES_${PN}+="/usr/etc/*"
FILES_${PN}-dev+="/usr/etc/*"
```

  

## 4. write our own image

[up](#vsomeip project)

we need now to create our image **vsomeip-image.bb** and base it on **core-image-base**

our image needs to be in **meta-custom/recipes-core/images/vsomeip-image.bb**



to base our image on **core-image-base** we use the word **require** as in the example

```sh
require recipes-core/images/core-image-base.bb
```



we will also have to install our **vsomeip** application + **openssh** application for that we will have to append those to the **IMAGE_INSTALL** variable

```sh
IMAGE_INSTALL += "openssh vsomeip"
```



## 5. generate our image & SDK 

[up](#vsomeip project)

then we will bitbake our image and sdk using

```sh
bitbake vsomeip-image # create the image
bitbake vsomeip-image -c populate_sdk # generate the installer of the SDK in the tmp/deploy/sdk folder
# we will have to run the generated installer using the shell script inside tmp/deploy/sdk
```

we will have to run the generated installer using the shell script inside **tmp/deploy/sdk** 

```sh
# install the SDK on your machine 
./poky-glibc-x86_64-vsomeip-image-base-cortexa7t2hf-neon-vfpv4-raspberrypi2-toolchain-3.1.19.sh 
```

then inside the SDK we will source the environment to setup the environment for our application compilation 

```sh
. /opt/poky/3.1.19/environment-setup-cortexa7t2hf-neon-vfpv4-poky-linux-gnueabi
```

## 6. build **applications** of vsomeip using SDK and test on **qemu** of **beaglebone-yocto**.

We have our applications in the folder beside this readme.md file in [applications_code/](https://github.com/ahmedhussien91/Linux-yocto-Excersises/tree/main/yocto/vsomeip/applications_code)

Ensure that you sourced the SDK before compilation

```sh
# Setup Cross compilation environment (update env values like `CC` for cross compilation)
. /opt/poky/3.1.19/environment-setup-cortexa7t2hf-neon-vfpv4-poky-linux-gnueabi
# from applications_code/
mkdir build
cd build
cmake ..
make
```

this will output two binaries in **build/** 

- **client-app**
- **server-app**

you can check that this application is built for our target using **file**

```sh
file client-app 
```

> client-app: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, BuildID[sha1]=206c3659242406fe8fdb8e26e123b5a462cc643f, for GNU/Linux 3.2.0, with debug_info, not stripped

### starting machine

to start **qemu** for this machine run this command

```sh
runqemu nographic
```

> ...
>
> runqemu - INFO - Setting up tap interface under sudo
> runqemu - INFO - Network configuration: ip=192.168.7.2::192.168.7.1:255.255.255.0
>
> ...

to know our PC ip on another PC terminal

```sh
ifconfig
```

> ...
>
> tap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet 192.168.7.1  netmask 255.255.255.255  broadcast 192.168.7.255
>         inet6 fe80::104a:f6ff:fe1d:142c  prefixlen 64  scopeid 0x20<link>
>         ether 12:4a:f6:1d:14:2c  txqueuelen 1000  (Ethernet)
>         RX packets 6  bytes 516 (516.0 B)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 45  bytes 7021 (7.0 KB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>
> ...

Note our setup now is 

**Qemu (linux - ip= 192.168.7.2)** <--------------> **Our Development machine (ip=192.168.7.1)**

to make sure everything is working fine try pinging 192.168.7.1 from Target (Qemu)

```sh
ping 192.168.7.2
```

> PING 192.168.7.1 (192.168.7.1): 56 data bytes
> ping: sendto: Network is unreachable



we might need to configure the **ip** of our target using 

```sh
ifconfig eth0 192.168.7.2
```

then 

```sh
ping 192.168.7.1
```

> PING 192.168.7.1 (192.168.7.1): 56 data bytes
> 64 bytes from 192.168.7.1: seq=0 ttl=64 time=16.028 ms
> 64 bytes from 192.168.7.1: seq=1 ttl=64 time=3.560 ms
> 64 bytes from 192.168.7.1: seq=2 ttl=64 time=0.644 ms
>
> ...

### transferring the application to qemu machine

we need to transfer the compiled applications **client-app** and **server-app** to the target for this we need to use **SCP** (secured copy)

after changing the directory to build folder of **someip** applications (**applications_code/build/**) we will do 

```sh
scp client-app root@192.168.7.2:/usr/bin
```

> The authenticity of host '192.168.7.2 (192.168.7.2)' can't be established.
> ED25519 key fingerprint is SHA256:8kh75rBK5AuCM8e+JtrM9WAuX9PV13uj1sOJz9CHebU.
> This key is not known by any other names
> Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
> Warning: Permanently added '192.168.7.2' (ED25519) to the list of known hosts.
> client-app                                                                                                                                                               100%  143KB   1.0MB/s   00:00    

Note: press **yes**

```sh
scp server-app root@192.168.7.2:/usr/bin
```

> server-app                                                                                                                                                               100%  122KB   3.5MB/s   00:00    

### run application on target 

from terminal in your machine we should start an **ssh** connection with target and execute the **server-app** using the following command

```sh
ssh root@192.168.7.2
server-app
```

> 2022-09-07 04:51:57.006584 [info] Parsed vsomeip configuration in 2ms
> 2022-09-07 04:51:57.168831 [info] Configuration module loaded.
> 2022-09-07 04:51:57.207564 [info] Initializing vsomeip application "World".
> 2022-09-07 04:51:57.258114 [info] Instantiating routing manager [Host].
> 2022-09-07 04:51:57.371981 [info] create_local_server Routing endpoint at /tmp/vsomeip-0
> 2022-09-07 04:51:57.492842 [info] Service Discovery enabled. Trying to load module.
> 2022-09-07 04:51:57.602012 [info] Service Discovery module loaded.
> 2022-09-07 04:51:57.699274 [info] Application(World, 0100) is initialized (11, 100).
> 2022-09-07 04:51:57.759984 [info] OFFER(0100): [1234.5678:0.0] (true)
> 2022-09-07 04:51:57.829625 [info] Listening at /tmp/vsomeip-100
> 2022-09-07 04:51:57.924929 [info] Starting vsomeip application "World" (0100) using 2 threads I/O nice 255
> 2022-09-07 04:51:58.070017 [info] shutdown thread id from application: 0100 (World) is: b60db450 TID: 440
> 2022-09-07 04:51:58.097342 [info] main dispatch thread id from application: 0100 (World) is: b68dc450 TID: 439
> 2022-09-07 04:51:58.224269 [info] Watchdog is disabled!
> 2022-09-07 04:51:58.320119 [info] io thread id from application: 0100 (World) is: b6f96300 TID: 438
> 2022-09-07 04:51:58.398562 [info] vSomeIP 3.1.20.3 | (default)
> 2022-09-07 04:51:58.414266 [info] io thread id from application: 0100 (World) is: b4cfe450 TID: 442
> 2022-09-07 04:51:58.544842 [info] Network interface "lo" state changed: up
> 2022-09-07 04:52:08.563760 [info] vSomeIP 3.1.20.3 | (default)
> 2022-09-07 04:52:18.571019 [info] vSomeIP 3.1.20.3 | (default)
> 2022-09-07 04:52:25.001525 [info] Application/Client 0101 is registering.
> 2022-09-07 04:52:25.255505 [info] Client [100] is connecting to [101] at /tmp/vsomeip-101
> 2022-09-07 04:52:25.554174 [info] REGISTERED_ACK(0101)
> 2022-09-07 04:52:25.679049 [info] REQUEST(0101): [1234.5678:255.4294967295]
> 2022-09-07 04:52:28.581001 [info] vSomeIP 3.1.20.3 | (default)

Start another terminal on pc and execute the client-app using the following command

```sh
ssh root@192.168.7.2
client-app
```

> Last login: Fri Oct  7 04:51:53 2022 from 192.168.7.1
> root@beaglebone-yocto:~# client-app 
> 2022-09-07 04:52:25.038708 [info] Parsed vsomeip configuration in 9ms
> 2022-09-07 04:52:25.169684 [info] Configuration module loaded.
> 2022-09-07 04:52:25.212308 [info] Initializing vsomeip application "Hello".
> 2022-09-07 04:52:25.255468 [info] Instantiating routing manager [Proxy].
> 2022-09-07 04:52:25.309517 [info] Client [ffff] is connecting to [0] at /tmp/vsomeip-0
> 2022-09-07 04:52:25.367256 [info] Application(Hello, ffff) is initialized (11, 100).
> 2022-09-07 04:52:25.437322 [info] Starting vsomeip application "Hello" (ffff) using 2 threads I/O nice 255
> 2022-09-07 04:52:25.538980 [info] shutdown thread id from application: ffff (Hello) is: b61a0450 TID: 451
> 2022-09-07 04:52:25.568254 [info] main dispatch thread id from application: ffff (Hello) is: b69a1450 TID: 450
> 2022-09-07 04:52:25.686851 [info] io thread id from application: ffff (Hello) is: b6ff5300 TID: 449
> 2022-09-07 04:52:25.700969 [info] io thread id from application: ffff (Hello) is: b55ff450 TID: 452
> 2022-09-07 04:52:25.497267 [info] Listening at /tmp/vsomeip-101
> 2022-09-07 04:52:25.895299 [info] Client 101 (Hello) successfully connected to routing  ~> registering..
> 2022-09-07 04:52:25.507745 [info] Application/Client 101 (Hello) is registered.
> Service [1234.5678] is NOT available.
> 2022-09-07 04:52:25.766219 [info] ON_AVAILABLE(0101): [1234.5678:0.0]
> Service [1234.5678] is available.

Note Service is available



## 7 & 8 & 9

you should repeat the steps **3, 4, 5** without the SDK generation step but for the recipes **vsomeip-server_1.0.bb** & **vsomeip-client_1.0.bb** which implement the applications

Implement the recipes to fetch the application **locally** without any git repos, in other words: 

- download the application by downloading this [repo](https://github.com/ahmedhussien91/Linux-yocto-Excersises/tree/main/yocto/vsomeip/applications_code) 

- copy code to your **meta-custom** layer
- implement the recipe for this local code
- include it in the **vsomeip-image.bb**
- `bitbake vsomeip-image.bb`
- `runqemu nographic` to start image
- `ps -aux` to see the applications running 

 
