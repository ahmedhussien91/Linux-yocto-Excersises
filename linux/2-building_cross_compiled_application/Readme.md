# building_cross_compiled_application

Remember:

- toolchain components:
  - binutils
  - kernel headers
  - C/C++ compiler
  - CLIB
  - GDB debugger

- main tool chain options
  - ABI
  - floating point support 
  - cpu optimization flag



## downloading crosstool-ng

- install needed requirements

  ```sh
  sudo apt install build-essential git autoconf bison flex texinfo help2man gawk \
  libtool-bin libncurses5-dev unzip
  ```

- download crosstool-ng

  ```sh
  git clone https://github.com/crosstool-ng/crosstool-ng
  cd crosstool-ng/
  git checkout 25f6dae8
  ```

## configuring  and building crosstool-ng

- generate **configure** script

  ```sh
  ./bootstrap
  ```

- choose to compile crosstool-ng locally 

  ```sh
  ./configure --enable-local
  make
  ```

- try 

  ```sh
  ./ct-ng help
  ```



## using crosstool-ng to build our toolchain

- we can load ARM cortex-A9 sample from samples included under `samples/` 

  ```sh
  ./ct-ng list-samples
  ./ct-ng arm-cortexa9_neon-linux-gnueabihf
  ```

  

- configure the toolchain

  ```sh 
  ./ct-ng menuconfig
  ```

- pickup the following configurations (you can search using `/`)

  - In `path and misc` options 
    - for  `Maximum log level to see:` chose DEBUG
  - In `C-library`
    - set `C library` to `LIB_MUSL`(musl)
  - In `C compiler`:
    - make sure that you support C++ `CC_LANG_CXX`
  - In `debug facilities` 
    - disable every thing except `DEBUG_STRACE` 

- build using 

  ```sh 
  ./ct-ng build
  ```

  - **output**: start building tool chain
  - notice `.build/` folder which is the output of the build 

## checking toolchain output in `~/x-tools`

- tool is installed inside `~/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/bin`, to use it add it to your path variable `PATH`

  ```sh 
  PATH=$PATH:~/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/bin/
  arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -v
  ```

  > ...
  > Target: arm-cortexa9_neon-linux-uclibcgnueabihf
  > ... --build=x86_64-build_pc-linux-gnu --host=x86_64-build_pc-linux-gnu --target=arm-cortexa9_neon-linux-uclibcgnueabihf 
  >
  > ... --with-sysroot=/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot 
  >
  > ... --enable-languages=c,c++ --with-cpu=cortex-a9 --with-fpu=neon --with-float=hard 
  >
  > ... --with-pkgversion='crosstool-NG 1.24.0.489_25f6dae'

  **NOTE:**

  - **--build**=x86_64-build_pc-linux-gnu
  - **--host**=x86_64-build_pc-linux-gnu 
  - **--target**=arm-cortexa9_neon-linux-uclibcgnueabihf 
  - **--with-sysroot**=/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot
  - **--enable-languages**=c,c++
  - notice also the compiler name contain: **CPU-cpu_vairiant-kernel-CLIB_GNU_ABI_floatingPoint-programName**

### sysroot folder

You will find the following subdirectories in **sysroot**:

- **lib**: Contains the **shared objects** for the **C library** and the **dynamic linker/loader**, ld-linux
- **usr/lib**: The **static library archive files** for the **C library**, and any other libraries that may be installed subsequently
- **usr/include**: Contains the headers for all the libraries
- **usr/bin**: Contains the **utility programs** that run on the target, such as the **ldd** command
- **usr/share**: Used for **localization** and **internationalization**
- **sbin**: Provides the **ldconfig** utility, used to optimize library loading paths



## Cross Compile using toolchain built (folder 1/)

- try compiling file with `-v` option

  ```sh
  arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -c -g -Wall error_functions.c -v
  ```

  >...
  >COLLECT_GCC=arm-cortexa9_neon-linux-uclibcgnueabihf-gcc
  >Target: arm-cortexa9_neon-linux-uclibcgnueabihf
  >...
  >gcc version 11.2.0 (crosstool-NG 1.24.0.489_25f6dae) 
  >COLLECT_GCC_OPTIONS='-c' '-g' '-Wall' '-v' '-mcpu=cortex-a9' '-mfloat-abi=hard' '-mfpu=neon' '-mtls-dialect=gnu' '-marm' '-mlibarch=armv7-a+mp+sec+simd' '-march=armv7-a+mp+sec+simd'
  >... -mcpu=cortex-a9 -mfloat-abi=hard -mfpu=neon -mtls-dialect=gnu -marm -mlibarch=armv7-a+mp+sec+simd -march=armv7-a+mp+sec+simd -g -Wall -version -o /tmp/ccNn7WLZ.s
  >GNU C17 (crosstool-NG 1.24.0.489_25f6dae) version 11.2.0 (arm-cortexa9_neon-linux-uclibcgnueabihf)
  >    compiled by GNU C version 9.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.0, isl version isl-0.24-GMP
  >
  >     ...
  >#include <...> search starts here:
  >/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/include
  >/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/include-fixed
  >/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/../../../../arm-cortexa9_neon-linux-uclibcgnueabihf/include
  >/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot/usr/include
  > End of search list.
  > GNU C17 (crosstool-NG 1.24.0.489_25f6dae) version 11.2.0 (arm-cortexa9_neon-linux-uclibcgnueabihf)
  >    compiled by GNU C version 9.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.0, isl version isl-0.24-GMP
  > 
  >...
  >COLLECT_GCC_OPTIONS='-c' '-g' '-Wall' '-v' '-mcpu=cortex-a9' '-mfloat-abi=hard' '-mfpu=neon' '-mtls-dialect=gnu' '-marm' '-mlibarch=armv7-a+mp+sec+simd' '-march=armv7-a+mp+sec+simd'
  >     /home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/../../../../arm-cortexa9_neon-linux-uclibcgnueabihf/bin/as -v -march=armv7-a+mp+sec -mfloat-abi=hard -mfpu=neon -meabi=5 -o error_functions.o /tmp/ccNn7WLZ.s
  >GNU assembler version 2.37 (arm-cortexa9_neon-linux-uclibcgnueabihf) using BFD version (crosstool-NG 1.24.0.489_25f6dae) 2.37
  >COMPILER_PATH=/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/libexec/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/libexec/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/libexec/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/../../../../arm-cortexa9_neon-linux-uclibcgnueabihf/bin/
  >LIBRARY_PATH=/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/lib/gcc/arm-cortexa9_neon-linux-uclibcgnueabihf/11.2.0/../../../../arm-cortexa9_neon-linux-uclibcgnueabihf/lib/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot/lib/:/home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot/usr/lib/
  >COLLECT_GCC_OPTIONS='-c' '-g' '-Wall' '-v' '-mcpu=cortex-a9' '-mfloat-abi=hard' '-mfpu=neon' '-mtls-dialect=gnu' '-marm' '-mlibarch=armv7-a+mp+sec+simd' '-march=armv7-a+mp+sec+simd'
  
- compile application using make 

  ```sh
  make 
  ```

  > arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -c -g -Wall error_functions.c 
  > arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -c -g -Wall get_num.c 
  > arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -c -g -Wall main.c 
  > arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -o test error_functions.o get_num.o main.o  

  

- check the output file `test`

  ```sh 
  file test
  ```

  > test: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-uClibc.so.0, with debug_info, not stripped

  - arm executable
  - dynamically linked to uclibc that we used in configuration

- try using `ldd` to find the needed dynamic libraries for `test`

  ```sh
  ldd test
  ```

  > ​        not a dynamic executable

- try again but with 

  ```sh
  arm-cortexa9_neon-linux-uclibcgnueabihf-ldd --root /home/ahmed/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot test
  ```

  > libc.so.0 => /lib/libc.so.0 (0xdeadbeef)
  > ld-uClibc.so.1 => /lib/ld-uClibc.so.1 (0xdeadbeef)

- try to relink it with `-static` option, compile all libraries statically

  ```sh
  arm-cortexa9_neon-linux-uclibcgnueabihf-gcc -o test_static error_functions.o get_num.o main.o -static
  ```

  - try 

    ```sh
    file test_static
    ```

    > test_static: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, with debug_info, not stripped

    ```sh
    ls -l 
    ```

    > -rwxrwxr-x 1 ahmed ahmed  20932 سبت  2 23:58 test
    > -rwxrwxr-x 1 ahmed ahmed 121072 سبت  3 00:11 test_static

- try executing file on your machine 

  ```sh
  ./test
  ```

  > bash: ./test: cannot execute binary file: Exec format error

  - we can execute it using qemu

    ```sh 
    sudo apt install qemu-user
    qemu-arm test
    ```

    > /lib/ld-uClibc.so.0: No such file or directory

    - we need to tell qemu where is the libraries to link with 

      ```sh 
      qemu-arm -L ~/x-tools/arm-cortexa9_neon-linux-uclibcgnueabihf/arm-cortexa9_neon-linux-uclibcgnueabihf/sysroot/ test
      ```

      > ERROR  [ENOENT No such file or directory] 

