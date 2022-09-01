# TODO 

- arc -> archive .a 
- objdump 
- file command
- find files that you use to compile application (toolchain header files)

# 1. building native application 

The target of this practice is to show the work off native tool-chain and try some of it's files and features
Remember the tool-chain consists of:

- binutils
- gcc compiler
- clibrary
- kernel headers
- gdp debugger

## Compilation using gcc

- identifying your gcc compiler

```sh
gcc -dumpmachine
```
>  x86_64-linux-gnu



### compilation using gcc 

To compile the application we will follow the normal procedures
- compile each file into object
- link all object files into binary 

```sh
gcc -c -g -Wall error_functions.c 
gcc -c -g -Wall get_num.c 
gcc -c -g -Wall main.c 
gcc -o test error_functions.o get_num.o main.o
```

### checking the libraries used by default

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



# using some of binutils

arc -> archive

