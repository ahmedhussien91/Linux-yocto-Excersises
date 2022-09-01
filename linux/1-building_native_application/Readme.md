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
- output 

 > x86_64-linux-gnu



##  

## compilation using gcc 

To compile the application we will follow the normal procedures
- compile each file into object
- link all object files into binary 

```sh
gcc -c -g -Wall error_functions.c 
gcc -c -g -Wall get_num.c 
gcc -c -g -Wall main.c 
gcc -o test error_functions.o get_num.o main.o
```



# using some of binutils

