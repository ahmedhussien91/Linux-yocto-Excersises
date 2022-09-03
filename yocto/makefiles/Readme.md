# todo 
- make is binary( > which make ), program that parses what you write and execute your code
- target : dependency , are considered by default files, .PHONY: for commands
- make is not only about C it execute any command that you write
- tabs and structures are important
- make has functions that simplifies your life Ex. $(shell )
- make is written to simplify your life 

# 1. Make Files

- `make` is a program 

  ```sh
  which make
  ```

  > /usr/bin/make

  

- this program always looks for a file that is called `makefile` to start it's execution, type `make` where `makefile` doesn't exist 

  ```sh
  make
  ```

  > make: *** No targets specified and no makefile found.  Stop.

  
## makefile concept (inside a different folder)

- entry point of make is **target** `all`

- `all` has a list of **dependencies** that must exist in makefile

- Makefile exercise

  - create make file with those lines 

  ```makefile
  all: target1 target2 target3
  ```

  - then `make`

  - > make: *** No rule to make target 'target1', needed by 'all'.  Stop.

  - make tried to search for `target1` either as a **file** or as another **target** in makefile and didnot find it 

  - create file `target1` using `touch target1` then `make`

  - > make: *** No rule to make target 'target2', needed by 'all'.  Stop.

  - add those lines for makefile then `make`

    ```makefile
    target2: 
    	touch target2
    	
    target3: 
    	touch target3
    ```

    > touch target2
    > touch target3

  - `make` again

    > make: Nothing to be done for 'all'.

  - make did nothing as all targets exists as a files on pc now 

  - add dependency for `target3`  `dep1` and `make`

    > make: *** No rule to make target 'dep1', needed by 'target3'.  Stop.

  - couldn't file `dep1` that `target3` depend on, create `dep1` file by using `touch dep1` and `make`

    > touch target3

  - Executed only `target3` that because it's the only thing that was changed

- The same applies for C we need to compile multiple `.c` files and create multiple `.o` 

  - This process takes alot of time and produces all `.o`'s  files for `.c` 
  - what if after this i needed to change a `.c` file, Do I have to build all the `.c` again ? (no, make is the solution) 




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



To compile using make we use this makefile, let's go through it  

```sh

# Kierans Generic Makefile (mo)
# www.kieranbingham.co.uk
# simplified by me Ah.hu.sabry@gmail.com

# Beware, This will create this application
TARGET  := test

# Create the target lists of current c files directory
SOURCES := $(wildcard *.c)
# Cread a list of objects by replacing .c with .o
OBJECTS  := $(SOURCES:.c=.o)

# Defaul Compilation flags  (`-g` for debugging symbols, `-Wall` display all warnings)
CFLAGS += -g -Wall
#linking flags 
LDLIBS += 

# Top level Build Rule
all: ${TARGET}

# compile each c file into an object file '-c'
# %.o marks any target that ends with '.o'
# %.c marks the same target but with ending '.c'
%.o: %.c
	gcc -c $(CFLAGS) $< 

# Build the application
$(TARGET): $(OBJECTS)
	gcc -o $@ $^ $(LDLIBS) 

clean:
	@rm -f $(TARGET) $(OBJECTS) 

help: printvars helpsummary

helpsummary:
	@echo "TARGET  : $(TARGET)"
	@echo "SOURCES : $(SOURCES)"
	@echo "OBJECTS : $(OBJECTS)"
	@echo "CFLAGS  : $(CFLAGS)"
	@echo "LDLIBS  : $(LDLIBS)"
```



- All Variables in the make must be set by someone
  - sometimes the toolchain can set some variables for you
  - people always use some commonly named variables
    - CFLAGS
    - CC or CROSS_COMPILE
    - SOURCES
    - OBJECTS 
    - LDLIBS

