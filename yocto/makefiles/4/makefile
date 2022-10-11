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
