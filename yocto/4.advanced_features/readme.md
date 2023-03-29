# Patch Kernel Code

let's use `devshell` and `.bbappend` to patch the kernel code to print **Hellooooooooooooooooo from kernelllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll**

first we will use the `devshell` to develop in the kernel code and get a patch file that we will then use in `.bbappend` file to patch the kernel code



## devshell

Start development shell for kernel

```sh
bitbake -c devshell virtual/kernel
# prepare the environment for development in the kernel
```

this will open a shell that is ready for development in `virtual/kernel` we open the `init/main.c` and add line `printk("Hellooooooooooooooooo from kernelllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");`

then 

```sh
vim init/main.c
# add printk("Hellooooooooooooooooo from kernelllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll"); in function start_kernel()
```

close this shell the compile using 

```sh
bitbake -c compile virtual/kernel
```

after compiling successfully and test the output image we can create a patch and append it by default in the kernel using the `.bbappen`

```sh
bitbake -c devshell virtual/kernel # open devshell
git commit -a -m "add print in kernel" # commit changes 
mkdir -p ~/Documents/yocto_organized/layers/meta-sw/recipes-kernel/linux/files # directory is make in the same folder highrarchy of `linux-yocto` recipe which it will append 
git format-patch -1 -o  ~/Documents/yocto_organized/layers/meta-sw/recipes-kernel/linux/files
```

> /home/ahmed/Documents/yocto_organized/layers/meta-sw/recipes-kernel/linux/files/0001-add-print.patch

## bbappend recipes

we will now in folder `~/Documents/yocto_organized/layers/meta-sw/recipes-kernel/linux/` write our `linux-yocto_%.bbappend` to add this patch to the kernel

**linux-yocto_%.bbappend**

```sh
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-add-print.patch \
			"
```

then just build and run the image and you should see **Hellooooooooooooooooo from kernelllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll** in startup messages of the kernel

**Note:** you may need to add ` loglevel=6 ` in **Linux command line parameters** while booting to see this print

