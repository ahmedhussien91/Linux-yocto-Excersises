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

- use `file` command to display information about your file 

```sh
file test
```

> test: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=c829bca7c053d79d87ce09b30d02d48bad37fd9d, for GNU/Linux 3.2.0, with debug_info, not stripped



#### checking the libraries and flags of gcc compiler

in c you always see the #include <> and you don't know where is it, it's in your compiler files

- you can  show you all the compiler default included paths, included library

```sh 
gcc -### 
```



- also dump the default specs of the compiler

```sh
gcc -dumpspecs
```



- while compiling you can see additional information also by adding `-v` in compilation line

```sh
gcc -c -v -g -Wall get_num.c
```

- note that the assembler is executed by default in this command in line

> as -v --64 -o get_num.o /tmp/ccvoRLS9.s



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



## using arc

- you can build a `.a` library using command `arc` 
- `.a` file is an archive file of multiple `.o` files that doesn't contain a `main()` 

### why to use libraries ? 

- you are not always providing the whole component you can provide only a library
- libraries are easier if they are integrated in multiple components 

- .... 

### creating static libraries using ar  (folder 2/)

- `ar` can group a set of object files into a single `.a` library file  
- Ex. using the `.o` files to generate `.a` file using command

```sh
cd lib
ar -rcs liberror.a get_num.o error_functions.o
ls
```

> error_functions.o  get_num.o  liberror.a

#### using static library 

- To compile `main.c` using `liberror.a` library

  ```sh
  # generate main.o
  gcc -c main.c -I./include 
  # generate test executable
  gcc -o test main.o lib/liberror.a 
  ```

  -  `.a` library and `.h` files needed to be supplied to the user of the package 

### creating dynamic libraries with gcc  (folder 3/)

- you can also create a dynamic library that can link with multiple applications in **runtime** 
- dynamic libraries is to exist as a part of system package 
- dynamic libraries don't duplicate code size while linking with multiple applications
- see this [Tutorial](https://docencia.ac.upc.edu/FIB/USO/Bibliografia/unix-c-libraries.html)

- to create a dynamic library we have to recompile the same applications with `-fpic` (position independent code)

  ```sh 
  # making `foo` library 
  gcc -c -g -Wall -fPIC foo.c  
  gcc -shared -o libfoo.so foo.o
  ```

- compile application with shared library 

  ```sh
  # main.o
  gcc -c main.c
  # link application with shared library 
  # `-L` add current director of libraries search path
  # `-l` link with foo library
  gcc main.o -L. -lfoo -o test
  # same thing, libfoo.so must be in current directory
  gcc main.o libfoo.so -o test
  ```

- run application 

  ```sh 
  ./test
  ```

  > ./test: error while loading shared libraries: libfoo.so: cannot open shared object file: No such file or directory

- we need to set the variable `LD_LIBRARY_PATH` to the `libfoo.so` folder path for the **dynamic system loader** to find our shared libraries

  ```sh
  # go to current directory of `libfoo.so` then
  LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH
  ./test
  ```

  > This is a shared library test...
  > Hello, I am a shared library

  