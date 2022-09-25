# 1. building native application 

The target of this practice is to show the work off native tool-chain and try some of it's files and features
**Remember** the tool-chain consists of:

- binutils
- gcc compiler
- clibrary
- kernel headers
- gdp debugger

## Compilation using gcc (folder 1/)

- identifying your **gcc** compiler

```sh
gcc -dumpmachine
```
>  x86_64-linux-gnu



### 1. compilation using gcc 

To compile the application we will follow the normal procedures
- compile each file into object
- link all object files into binary 

```sh
gcc -c -g -Wall error_functions.c 
gcc -c -g -Wall get_num.c 
gcc -c -g -Wall main.c 
gcc -o test error_functions.o get_num.o main.o
```

Note: `-c` Compile and assemble, but do not link

`-g` add debugging symbos

`-Wall` enable **all** warnings



#### Read Executable using `file`, `readelf` and `objdumb`

- use `file` command to display information about your file 

```sh
file test
```

> test: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=c829bca7c053d79d87ce09b30d02d48bad37fd9d, for GNU/Linux 3.2.0, with debug_info, not stripped

- you can also look at the header of the `test` file by using

  ```sh
  readelf -h
  ```

  > ELF Header:
  >   Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  >   Class:                             ELF64
  >   Data:                              2's complement, little endian
  >   Version:                           1 (current)
  >   OS/ABI:                            UNIX - System V
  >   ABI Version:                       0
  >   Type:                              DYN (Position-Independent Executable file)
  >   Machine:                           Advanced Micro Devices X86-64
  >   Version:                           0x1
  >   Entry point address:               0x2240
  >   Start of program headers:          64 (bytes into file)
  >   Start of section headers:          27224 (bytes into file)
  >   Flags:                             0x0
  >   Size of this header:               64 (bytes)
  >   Size of program headers:           56 (bytes)
  >   Number of program headers:         13
  >   Size of section headers:           64 (bytes)
  >   Number of section headers:         37
  >   Section header string table index: 36

  you can also see help of read elf and issue multiple commands to get more information about the elf file, see [here](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)

- you can see also symbols that is defined & undefined in the object file, 

  - Ex. main.c -> main() should be defined, open() is an external function

    ```sh
    objdump -x main.o | grep main
    ```

    > 0000000000000000 g     F .text	0000000000000049 main

    ```sh
    objdump -x main.o | grep open
    ```

    > 0000000000000000         \*UND*	0000000000000000 open



#### checking the libraries and flags of gcc compiler

in c you always see the #include <> and you don't know where is it, it's in your compiler files

- you can  show you all the compiler default configurations, note those output configurations

```sh 
gcc -### 
```

> Target: x86_64-linux-gnu
>
> ... --enable-languages=c,ada,c++,go,brig,d,fortran,objc,obj-c++,m2
>
> ... --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu

- while compiling you can see additional information also by adding `-v` in compilation line

```sh
gcc -c -v -g -Wall get_num.c
```

> ...
>
> COLLECT_GCC_OPTIONS='-c' '-v' '-g' '-Wall' '-mtune=generic' '-march=x86-64'
>
> ...
>
> #include <...> search starts here:
>  /usr/lib/gcc/x86_64-linux-gnu/11/include
>  /usr/local/include
>  /usr/include/x86_64-linux-gnu
>  /usr/include
>
> ... 
>
> as -v --64 -o get_num.o /tmp/ccvoRLS9.s
>
> ... 
>
> COMPILER_PATH=/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/
> LIBRARY_PATH=/usr/lib/gcc/x86_64-linux-gnu/11/:/usr/lib/gcc/x86_64-linux-gnu/11/../../../x86_64-linux-gnu/:/usr/lib/gcc/x86_64-linux-gnu/11/../../../../lib/:/lib/x86_64-linux-gnu/:/lib/../lib/:/usr/lib/x86_64-linux-gnu/:/usr/lib/../lib/:/usr/lib/gcc/x86_64-linux-gnu/11/../../../:/lib/:/usr/lib/

```sh
find /usr/include/ -name fcntl.h
```

>/usr/include/fcntl.h
>/usr/include/asm-generic/fcntl.h
>/usr/include/x86_64-linux-gnu/asm/fcntl.h
>/usr/include/x86_64-linux-gnu/sys/fcntl.h
>/usr/include/x86_64-linux-gnu/bits/fcntl.h
>/usr/include/linux/fcntl.h

it will use the first one which exist in `#include <...> search starts here:` and also included in the `find /usr/include/ -name fcntl.h`, note that we use `#include <fcntl.h>` directly without any folders in the code



- use `gcc --help` if you don't remember any command :)



# 2. using some of binutils

Remember: 

- `as`, the assembler, that generates binary code from assembler source code
- `ld`, the linker
- `ar`, `ranlib`, to generate .a archives (static libraries)
- `objdump`, `readelf`, `size,` `nm`, `strings`, to inspect binaries. Very useful analysis tools!
- `objcopy`, to modify binaries
- `strip`, to strip parts of binaries that are just needed for debugging (reducing their
  size).

## Using size,**strip**

- to find out the size of the each section we use `size`

```sh
size test main.o get_num.o error_functions.o
```

>    text    data     bss     dec     hex filename
>   10984    1800      48   12832    3220 test
>     159       0       0     159      9f main.o
>    1110       0       0    1110     456 get_num.o
>    3601    1064       0    4665    1239 error_functions.o

using size may help deciding where to start optimizing your code, generic overview of the object memory



- to minimize the size of the executable file and remove all symbols from it we use `strip`

```sh
strip -s -o test_stripped test
```

use `ls -l` and note the difference between the **test** and **test_stripped** file size

```sh 
ls -l 
```

> -rwxrwxr-x 1 ahmed ahmed 30936 سبت  2 10:57 test
> -rwxrwxr-x 1 ahmed ahmed 19648 سبت  2 10:59 test_stripped 

you can also check the removed sections by comparing the two binaries using `objdump`



## using arc to create a static library

- you can build a `.a` library using command `arc` 
- `.a` file is an archive file of multiple `.o` files that doesn't contain a `main()` 

### why to use libraries ? 

- you are not always providing the **whole component** you can provide only a library
- libraries are easier if they are integrated in multiple components 

- a lot of program implementations only provide a library functionality for you to implement you application 

- ...

### creating static libraries using ar  (folder 2/)

- `ar` can group a set of object files into a single `.a` library file  
- Ex. using the `.o` files to generate `.a` file using command

```sh
cd lib
ar -rcs liberror.a get_num.o error_functions.o
ls
```

> error_functions.o  get_num.o  liberror.a

Note: 

- The `'c'` flag tells ar to create the library if it doesn't already exist. 

- The `'r'` flag tells it to replace older object files in the library, with the new object files



#### using static library 

we have now created a library, let's see how to use it from user perspective 

- To compile `main.c` using `liberror.a` library

  ```sh
  # generate main.o
  gcc -c main.c -I./include 
  # generate test executable
  gcc -o test main.o lib/liberror.a 
  ```

  -  `.a` library and `.h` files needed to be supplied to the user of the package 
  
  

# 3. creating dynamic libraries with gcc  (folder 3/)

- you can also create a dynamic library that can link with multiple applications in **runtime** 
- dynamic libraries is to exist as a part of system package 
- dynamic libraries don't duplicate code size while linking with multiple applications
- see this [Tutorial](https://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html)

- to create a dynamic library we have to recompile the same applications with `-fpic` (position independent code)

  ```sh 
  # compiling object files with `-fPIC`
  gcc -c -g -Wall -fPIC error_functions.c 
  gcc -c -g -Wall -fPIC get_num.c 
  # making `liberror` library 
  gcc -shared -o liberror.so error_functions.o get_num.o 
  ```

- compile application with shared library 

  ```sh
  # link application with shared library 
  # `-L` add current director of libraries search path
  # `-l` link with foo library
  # `-I` to include header files path
  gcc main.c -L./lib -lerror -o test -I./include
  ```
  
- run application 

  ```sh 
  ./test
  ```

  > ./test: error while loading shared libraries: liberror.so: cannot open shared object file: No such file or directory

we need to be able to see the shared libraries on Runtime, if not the application will not start to do this we have 3 different ways, descried in the upcoming sections

### LD_LIBRARY_PATH

- we need to set the variable `LD_LIBRARY_PATH` to the `liberror.so` folder path for the **dynamic system loader** to find our shared libraries

  ```sh
  # go to current directory of `libfoo.so` then
  LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
  # Our directory is in LD_LIBRARY_PATH, but we did not export it. In Linux, if you do not export the changes to an environment variable, they will not be inherited by the child processes. 
  export LD_LIBRARY_PATH
  ./test
  ```

  > ERROR  [ENOENT No such file or directory] 


### rpath

rpath, or the run path, is a way of embedding the location of shared libraries in the executable itself, instead of relying on default locations or environment variables. We do this during the linking stage

`-Wl` sends comma-separated options to linker

```sh 
#remove LD_LIBRARY_PATH to make sure it won't compile
unset LD_LIBRARY_PATH
echo $LD_LIBRARY_PATH # output empty string 
# compile with rpath
gcc -L./lib -Wl,-rpath=./lib -Wall -o test main.c -lerror -I./include
# try the application
./test
```

> ERROR  [ENOENT No such file or directory] 



### using ldconfig

another way of pointing to the share library and making sure that any one can have access to it is to use the **ldconfig**

to do this we:

- copy the library to shared location
- update the dynamic linker configuration file and cache with this library

```sh
# copy to shared location
cp ./lib/liberror.so /usr/lib/
sudo chmod 0755 /usr/lib/liberror.so
# update the linker configuration
ldconfig # should update the cache file `/etc/ld.so.cache`
#list all libraries in the configuration file
ldconfig -p 
ldconfig -p | grep liberror.so
```

> ​        liberror.so (libc6,x86-64) => /lib/liberror.so



let's make sure we compile again and remove the **LD_LIBRARY_PATH**

```sh
unset LD_LIBRARY_PATH
gcc -L./lib -Wall -o test main.c -lerror -I./include
# run application again
./test
```

> ERROR  [ENOENT No such file or directory] 



### ldd command

you can use the command `ldd` to list the dynamic libraries dependencies of any application

```sh
ldd test
```

>         linux-vdso.so.1 (0x00007ffcbe8e7000)
>         liberror.so => /lib/liberror.so (0x00007f0f8b021000)
>         libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f0f8adf9000)
>         /lib64/ld-linux-x86-64.so.2 (0x00007f0f8b046000)

