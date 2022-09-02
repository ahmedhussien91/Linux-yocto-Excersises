
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
	@rm -f $(TARGET) $(TARGET)_stripped $(OBJECTS) 

help: printvars helpsummary

helpsummary:
	@echo "TARGET  : $(TARGET)"
	@echo "SOURCES : $(SOURCES)"
	@echo "OBJECTS : $(OBJECTS)"
	@echo "CFLAGS  : $(CFLAGS)"
	@echo "LDLIBS  : $(LDLIBS)"