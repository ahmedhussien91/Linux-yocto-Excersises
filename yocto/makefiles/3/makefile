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

.PHONY:
print: 
	echo "variaible var=$(var)"
	echo "$ (wildcard *.c) = $(wildcard *.c)"
