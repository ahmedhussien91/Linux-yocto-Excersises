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

### make entry point

- entry point of make is the first **target** by default

  ```makefile
  notall: 
          echo notall
  all: 
          echo all target                     
  ```

  **make** out:

  > echo notall
  > notall

  

- people always call this first target `all`

- usually `all` have as a dependencies the default outputs of the makefile

### makefile structure

 makefile structure consist of multiple **targets/rules**, **dependencies**(prerequisites) and **commands**

```makefile
target1: dependency1 dependency2
	command1
	command2
	...
target2: dependency3 dependency4
	command1
	command2
	...
rule1: dependency3 dependency4
	command1
	command2
	...
```

commands are **shell** commands

**Targets** are **files**, if this file exists target will not be executed

**dependencies** are **files** that must exist before the commands of target are run

**Targets** can depend on **dependencies** that can be targets that have other dependencies  

**tabs** and structures are important

#### Ex1

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
  	echo "creating file target2"
  	touch target2
  	
  target3: 
  	echo "creating file target3"
  	touch target3
  ```

  > touch target2
  > touch target3

- `make` again

  > make: Nothing to be done for 'all'.

- make did nothing as all targets exists as a files on pc now 

- add dependency for `target3`  `dep1`

  makefile becomes

  ```makefile
  all: target1 target2 target3
  
  target2:
  	echo "creating file target2"
  	touch target2
  	
  target3: dep1
  	echo "creating file target3"
  	touch target3
  ```

  then `make`

  > make: *** No rule to make target 'dep1', needed by 'target3'.  Stop.

- couldn't file `dep1` that `target3` depend on, create `dep1` **file** by using `touch dep1` 

- then `make`, output will be 

  > touch target3

- Executed only `target3` that because it's the only thing that was changed

#### Ex 2

- The same applies for our C we need to compile multiple `.c` files and create multiple `.o` 

  - This process takes alot of time and produces all `.o`'s  files for `.c` 
  - what if after this i needed to change a `.c` file, Do I have to build all the `.c` again ? (no, make is the solution) 

for our code example to build we need to do something like this

```makefile
all: test

test: error_functions.o get_num.o main.o
	gcc -o test error_functions.o get_num.o main.o
	
error_functions.o: error_functions.c
	gcc -c -g -Wall error_functions.c 

get_num.o: get_num.c
	gcc -c -g -Wall get_num.c 
	
main.o: main.c
	gcc -c -g -Wall main.c 
```

make will parse the file it will find **all**

**all** depend on **test** file

**test** file depend on **.o's**

each **.o** depend on **.c** file

all **.c** files exists

command in the **.o** target will generate the **.o** file using **.c** file as input for **gcc -c** operation

**.o's** exist it will act as input for the **test** file, **gcc -o test** operation will generate this file and all is done 

output of `make` command is:

> gcc -c -g -Wall error_functions.c 
> gcc -c -g -Wall get_num.c 
> gcc -c -g -Wall main.c 
> gcc -o test error_functions.o get_num.o main.o

Executing `make` command again will output:  

>  make: Nothing to be done for 'all'. 

changing in any **.c** will trigger again only the target that it's dependency changed

- change in **main.c** add some spaces

- then `make`

  > ​	gcc -c -g -Wall main.c 
  >
  > ​	gcc -o test error_functions.o get_num.o main.o

##### adding clean target

usually people add a target that is called **clean** to remove all the output of the build this is usually is something like this

```makefile
clean: 
	rm test error_functions.o get_num.o main.o
```

what if a file that is called **clean** is created, -> create a file that is called **clean**

```sh
touch clean
```

then `make clean` 

> make: 'clean' is up to date.

if we are sure that this will be rule (not a file) we can add it to `.PHONY` like this

```makefile
.PHONY: clean
clean: 
	rm test error_functions.o get_num.o main.o
```

`make` then `make clean` 

> rm test error_functions.o get_num.o main.o

`make clean` executes also **clean** file exists

  ### makefile functions and variables

#### Ex 3

makefile has **variables**

```makefile
# can be assigned like this 
TARGET  := test
CC := gcc
CFLAGS :=
LDFLAGS :=
CXX :=
CXXFLAGS :=
CPPFLAGS :=
var:= a bb ccc dddd

# used like this
all: $(TARGET)

test: error_functions.o get_num.o main.o
	$(CC) -o test error_functions.o get_num.o main.o
	
error_functions.o: error_functions.c
	$(CC) -c -g -Wall error_functions.c 

get_num.o: get_num.c
	$(CC) -c -g -Wall get_num.c 
	
main.o: main.c
	$(CC) -c -g -Wall main.c 
	
.PHONY: clean
clean: 
	rm test error_functions.o get_num.o main.o

.PHONY: print
print: 
	echo "variaible var=$(var)"
```

Execute `make print`

> echo "variaible var=a bb ccc dddd"
> variaible var=a bb ccc dddd

we have also some **functions** that can help you gather some information like **$(wildcard *.c)**

we can test this under **print** target like this 

```makefile
.PHONY: print
print: 
	echo "variaible var=$(var)"
	echo "$ (wildcard *.c) = $(wildcard *.c)"
```

`make print`

>echo "variaible var=a bb ccc dddd"
>variaible var=a bb ccc dddd
>echo "(wildcard *.c) = error_functions.c get_num.c main.c"
>(wildcard *.c) = error_functions.c get_num.c main.c

### wildcards

makefile has alot of wildcards like **%**, $<, $^, $@

let's print some of them

```makefile
# can be assigned like this 
TARGET  := test
CC := gcc
CFLAGS :=
LDFLAGS :=
CXX :=
CXXFLAGS :=
CPPFLAGS :=
var:= a bb ccc dddd

# used like this
all: $(TARGET)

test: error_functions.o get_num.o main.o
	$(CC) -o test error_functions.o get_num.o main.o
	echo "$ @=$@"
	echo "$ <=$<"
	echo "$ ^=$^"
	
error_functions.o: error_functions.c
	$(CC) -c -g -Wall error_functions.c 

get_num.o: get_num.c
	$(CC) -c -g -Wall get_num.c 
	
main.o: main.c
	$(CC) -c -g -Wall main.c 
	
.PHONY: clean
clean: 
	rm test error_functions.o get_num.o main.o

.PHONY: print
print: 
	echo "variaible var=$(var)"
```

`make`

> gcc -c -g -Wall error_functions.c 
> gcc -c -g -Wall get_num.c 
> gcc -c -g -Wall main.c 
> gcc -o test error_functions.o get_num.o main.o
> echo "@=test"
> @=test
> echo "<=error_functions.o"
> <=error_functions.o
> echo "^=error_functions.o get_num.o main.o"
> ^=error_functions.o get_num.o main.o

we can also change it to 

```makefile
# can be assigned like this 
TARGET  := test
CC := gcc
CFLAGS :=
LDFLAGS :=
CXX :=
CXXFLAGS :=
CPPFLAGS :=
var:= a bb ccc dddd

# used like this
all: $(TARGET)

test: error_functions.o get_num.o main.o
	$(CC) -o test error_functions.o get_num.o main.o
	echo "$ @=$@"
	echo "$ <=$<"
	echo "$ ^=$^"

%.o:%.c
	echo "target= $@"
	echo "dependency= $^"
	gcc -c -g -Wall $<
		
.PHONY: clean
clean: 
	rm test error_functions.o get_num.o main.o

.PHONY: print
print: 
	echo "variaible var=$(var)"
```

`make clean` then `make` again

> echo "target= error_functions.o"
> target= error_functions.o
> echo "dependency= error_functions.c"
> dependency= error_functions.c
> gcc -c -g -Wall error_functions.c
> echo "target= get_num.o"
> target= get_num.o
> echo "dependency= get_num.c"
> dependency= get_num.c
> gcc -c -g -Wall get_num.c
> echo "target= main.o"
> target= main.o
> echo "dependency= main.c"
> dependency= main.c
> gcc -c -g -Wall main.c
> gcc -o test error_functions.o get_num.o main.o
> echo "@=test"
> @=test
> echo "<=error_functions.o"
> <=error_functions.o
> echo "^=error_functions.o get_num.o main.o"
> ^=error_functions.o get_num.o main.o



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
	rm -f $(TARGET) $(OBJECTS) 

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
    - **CFLAGS**
    - **CC** or **CROSS_COMPILE**
    - **SOURCES**
    - **OBJECTS** 
    - **LDFLAGS**

