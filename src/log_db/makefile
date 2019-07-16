# the compiler: gcc for C program, define as g++ for C++
CC = g++

# compiler flags:
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
CFLAGS  = -g -Wall $(shell pkg-config --cflags --libs libmongoc-1.0)

# the build target executable:
TARGET = Database

all: $(TARGET)

$(TARGET): $(TARGET).c
	$(CC) $(CFLAGS) -o $(TARGET) $(TARGET).c

clean:
	$(RM) $(TARGET)



#./main.o --log --packet --ip 127.0.0.1 --status passed  --time 1563175501 --country US  --destination 127.0.0.2 --server #localhost  --reason reason2


