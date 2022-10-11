all: test

test: error_functions.o get_num.o main.o
	gcc -o test error_functions.o get_num.o main.o
	
error_functions.o: error_functions.c
	gcc -c -g -Wall error_functions.c 

get_num.o: get_num.c
	gcc -c -g -Wall get_num.c 
	
main.o: main.c
	gcc -c -g -Wall main.c 

.PHONY: clean
clean: 
	rm test error_functions.o get_num.o main.o
