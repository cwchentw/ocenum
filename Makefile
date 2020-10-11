ifeq ($(OS),Windows_NT)
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname -s 2>/dev/null || echo not')
endif

# Set the include path of GNUstep.
ifeq (,$(GNUSTEP_INCLUDE))
	GNUSTEP_INCLUDE=/usr/GNUstep/System/Library/Headers
endif

# Set the library path of GNUstep.
ifeq (,$(GNUSTEP_LIB))
	GNUSTEP_LIB=/usr/GNUstep/System/Library/Libraries
endif

GCC_LIB=$(shell sh -c 'dirname `gcc -print-prog-name=cc1 /dev/null`')

ifeq ($(detected_OS),Windows)
	TARGET=ocEnumDemo.exe
else
	TARGET=ocEnumDemo
endif

OBJS=OCEnum.o OCEnumValue.o main.o


# Set the include path of libobjc on non-Apple platforms.
OBJC_INCLUDE := -I $(GCC_LIB)/include

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $(TARGET) $(OBJS) -lobjc -lgnustep-base -L $(GNUSTEP_LIB)

%.o:%.m
ifeq ($(detected_OS),Darwin)
	$(CC) -std=c11 -c $< -o $@ $(CFLAGS) \
		-fconstant-string-class=NSConstantString
else
	$(CC) -std=c11 -c $< -o $@ $(CFLAGS) $(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
endif
		
clean:
	$(RM) $(TARGET) $(OBJS)