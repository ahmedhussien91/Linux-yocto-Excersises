# todo 
- make is binary( > which make ), program that parses what you write and execute your code
- target : dependency , are considered by default files, .PHONY: for commands
- make is not only about C it execute any command that you write
- tabs and structures are important
- make has functions that simplifies your life Ex. $(shell )
- make is written to simplify your life 

# 1. Make Files


## compilation using gcc maually 

To compile the application we will follow the normal procedures
- compile each file into object
- link all object files into binary 

```sh
gcc -c -g -Wall error_functions.c 
gcc -c -g -Wall get_num.c 
gcc -c -g -Wall main.c 
gcc -o test error_functions.o get_num.o main.o
```

