# U-BOOT

universal boot-loader

## Remember



## Lap

- we need to build u-boot using the toolchain we already built for ARM Vexpress Cortex A9

### Download U-boot

```sh 
git clone git@github.com:u-boot/u-boot.git
cd u-boot/
git checkout v2022.07
```

### Configure U-boot

```sh 
# set the corss toolchain that should be used 
export CROSS_COMPILE=arm-cortexa9_neon-linux-uclibcgnueabihf-
export ARCH=arm
# load the default configuration of ARM Vexpress Cortex A9
make vexpress_ca9x4_defconfig

```

- open configuration menu

  ```sh 
  make menuconfig
  ```

  note:

  Architecture select (ARM architecture)

  - we need to configure U-boot so that it stores it's environment inside a file called uboot.env in FAT filesystem on an MMC/SD card

    - unset Environment in flash memory `CONFIG_ENV_IS_IN_FLASH`

    - set Environment is in a FAT filesystem `CONFIG_ENV_IS_IN_FAT`

    - set Name of the block device for the Environment `CONFIG_ENV_FAT_INTERFACE`: mmc 

    - Device and partition for where to store the environment in FAT `CONFIG_ENV_
      FAT_DEVICE_AND_PART`: 0:1

      Note the above two commands correspond to the  arguments to `fatload` command [see this](https://stackoverflow.com/questions/60368553/what-does-fatload-mmc-and-bootm-means-in-the-uboot)

      

    - add support to **editenv** `CONFIG_CMD_EDITENV` and **bootd** `CONFIG_CMD_BOOTD`, under `Command line interface`

    
    
    

### Building U-BOOT

- run `make`  - renamed `image.h`, empty the path variable before building 

  ```sh
  file u-boot
  ```

  >  u-boot: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, with debug_info, not stripped

- we have built the uboot for our target with those configurations using cross-compiler for ARM target 

### Runnig UBOOT on Qemu

- to run u-boot on qemu we use command 

  ```sh
  qemu-system-arm -M vexpress-a9 -m 128M -nographic -kernel u-boot		
  ```

  > pulseaudio: set_sink_input_volume() failed
  > pulseaudio: Reason: Invalid argument
  > pulseaudio: set_sink_input_mute() failed
  > pulseaudio: Reason: Invalid argument
  >
  >
  > U-Boot 2020.04 (Sep 03 2022 - 18:53:44 +0200)
  >
  > DRAM:  128 MiB
  > WARNING: Caches not enabled
  > Flash: 128 MiB
  > MMC:   MMC: 0
  > Loading Environment from FAT... Card did not respond to voltage select!
  > In:    serial
  > Out:   serial
  > Err:   serial
  > Net:   smc911x-0
  > Hit any key to stop autoboot:  0 

  - -**M**: emulated machine 
  - -**m**: amount of memory emulated
  - -**kernel**: loads the binary passed directly in the emulated machine. 

  

#### playing with U-boot

##### creating SD-card

We will now add SD-card image to the QEMU virtual machine to store the U-Boot's Environment.

- create a 1GB file filled with zeros `sd.img`

  ```sh
  dd if=/dev/zero of=sd.img bs=1M count=1024
  ```

  > 1024+0 records in
  > 1024+0 records out
  > 1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.585817 s, 1.8 GB/s

- create partitions inside this SD-card simulated file

  ```sh 
  cfdisk sd.img
  ```

  - one partition 64MB / FAT16 / bootable
  - one partition 8MB / linux / for root filesystem
  - one partition that fills the rest of the SD card image / linux /data file system 
  - then `write` to apply changes

  > Syncing disks.

- use loop driver to emulate block devices for this image and it's partitions

  ```sh
  sudo losetup -f --show --partscan sd.img
  ```

  > /dev/loop28

  - -f: finds a free loop device
  - --show: show the loop device that is used
  - --partscan: scans the loop device for partitions and creates additional /dev/loop\<x>p\<y> block devices
  - note: a loop device is a regular file or device that is mounted as a file system. It may be thought of as a "pseudo device" because the operating system kernel treats the file's contents as a block device.

- format the first partition(p1) as FAT16 with a boot label 

  ```sh
  sudo mkfs.vfat -F 16 -n boot /dev/loop<x>p1
  ```

  > mkfs.fat 4.1 (2017-01-24)
  > mkfs.fat: warning - lowercase labels might not work properly with DOS or Windows

- release the loop device after finishing

  ```sh 
  sudo losetup -d /dev/loop<x>
  ```

  

##### testing U-boot's Env

- start Qemu with the Emulated SD card

  ```sh
  qemu-system-arm -M vexpress-a9 -m 128M -nographic \
  -kernel u-boot/u-boot \
  -sd sd.img
  ```

  `ctrl-A x` to exit qmeu

- set and store environment variable ---> reset ---> print variable

  ```sh 
  # setenv env value
  setenv foo bar
  saveenv
  reset
  printenv foo 
  ```

  > foo=bar

#### setup networking between Qemu(uboot) and host

- Create script `qemu-ifup` that will bring up a network interface between QEMU and the host

  ```sh
  #!/bin/sh
  ip a add 192.168.0.1/24 dev $1
  ip link set $1 up
  ```

  - then `chmod +x qemu-ifup`

- Start Qemu and set `U-boot`IP address to `192.168.0.100`

  ```sh 
  sudo qemu-system-arm -M vexpress-a9 -m 128M -nographic \
  -kernel u-boot/u-boot \
  -sd sd.img \
  -net tap,script=./qemu-ifup -net nic
  ```

  > WARNING: Image format was not specified for 'sd.img' and probing guessed raw.
  >          Automatically detecting the format is dangerous for raw images, write operations on block 0 will be restricted.
  >          Specify the 'raw' format explicitly to remove the restrictions.
  > pulseaudio: set_sink_input_volume() failed
  > pulseaudio: Reason: Invalid argument
  > pulseaudio: set_sink_input_mute() failed
  > pulseaudio: Reason: Invalid argument
  >
  >
  > U-Boot 2020.04 (Sep 03 2022 - 18:53:44 +0200)
  >
  > DRAM:  128 MiB
  > WARNING: Caches not enabled
  > Flash: 128 MiB
  > MMC:   MMC: 0
  > Loading Environment from FAT... *** Warning - bad CRC, using default environment
  >
  > In:    serial
  > Out:   serial
  > Err:   serial
  > Net:   smc911x-0
  > Hit any key to stop autoboot:  0 
  > MMC Device 1 not found
  > no mmc device at slot 1
  > switch to partitions #0, OK
  > mmc0 is current device
  > Scanning mmc 0:1...
  > smc911x: MAC 52:54:00:12:34:56
  > smc911x: detected LAN9118 controller
  > smc911x: phy initialized
  > smc911x: MAC 52:54:00:12:34:56
  > BOOTP broadcast 1
  > DHCP client bound to address 10.0.2.15 (1 ms)

  - -net tab: create a software network interface on the host side
  - -net nic: adds a network interface to the emulated machine 

  - on host machine check that there is now a `tab0` network interface 

  - on UBOOT cmdline

    ```sh
    setenv ipaddr 192.168.0.100
    setenv serverip 192.168.0.1
    saveenv
    ```

  - `ping 192.168.0.1` from uboot it should be alive 

    > smc911x: MAC 52:54:00:12:34:56
    > smc911x: detected LAN9118 controller
    > smc911x: phy initialized
    > smc911x: MAC 52:54:00:12:34:56
    > Using smc911x-0 device
    > smc911x: MAC 52:54:00:12:34:56
    > host 192.168.0.1 is alive

- we can also connect using `TFTP` and get some file `file.txt` from development workstation(host), by issuing from uboot: 

  ```sh 
  tftp 0x61000000 file.txt
  ```

  > smc911x: MAC 52:54:00:12:34:56
  > smc911x: detected LAN9118 controller
  > smc911x: phy initialized
  > smc911x: MAC 52:54:00:12:34:56
  > Using smc911x-0 device
  > TFTP from server 192.168.0.1; our IP address is 192.168.0.100
  > Filename 'file.txt'.
  > Load address: 0x61000000
  > Loading: #
  >          5.9 KiB/s
  > done
  > Bytes transferred = 13 (d hex)
  > smc911x: MAC 52:54:00:12:34:56

  **Note**: TFTP must be installed, configured and run on host machine 

  - install

  ```sh
  sudo apt install tftpd-hpa
  ```

  - configure

    ```sh
    sudo vi /etc/default/tftpd-hpa
    ```

    > /etc/default/tftpd-hpa
    >
    > TFTP_USERNAME="tftp"
    > TFTP_DIRECTORY="/srv/tftp"
    > TFTP_ADDRESS=":69"
    > TFTP_OPTIONS="--secure"

  - place file `file.txt` in default path 

    ```sh
    echo "7amada" > /srv/tftp/file.txt
    ```

  - check that tftp is working 

    ```sh 
    service --status-all 
    ```

    > [+] tftpd-hpa

- you can check the file contents using `md` memory dump of the same address

  ```sh 
  md 0x61000000
  ```

  >61000000: 616d6137 61616164 61616161 0000000a    7amadaaaaaaa....
  >61000010: 00000000 00000000 00000000 00000000    ................
  >61000020: 00000000 00000000 00000000 00000000    ................
  >61000030: 00000000 00000000 00000000 00000000    ................
  >61000040: 00000000 00000000 00000000 00000000    ................
  >61000050: 00000000 00000000 00000000 00000000    ................
  >61000060: 00000000 00000000 00000000 00000000    ................
  >61000070: 00000000 00000000 00000000 00000000    ................

  
