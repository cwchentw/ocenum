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

ifeq ($(detected_OS),Windows)
	DYNAMIC_LIB=libocenum.dll
	STATIC_LIB=libocenum.a
else
ifeq ($(detected_OS),Darwin)
	DYNAMIC_LIB=libocenum.dylib
else
	DYNAMIC_LIB=libocenum.so
endif
	STATIC_LIB=libocenum.a
endif

OBJS=OCEnum.o main.o


# Set the include path of libobjc on non-Apple platforms.
OBJC_INCLUDE := -I $(GCC_LIB)/include

.PHONY: all dynamic static clean

all: $(TARGET)

$(TARGET): $(OBJS) $(TARGET_OBJS) $(STATIC_LIB)
ifeq ($(detected_OS),Darwin)
	$(CC) -o $(TARGET) $(TARGET_OBJS) $(STATIC_LIB) \
		-lm -lobjc -framework Foundation
else
	$(CC) -o $(TARGET) $(TARGET_OBJS) $(STATIC_LIB) \
		-lm -lobjc -lgnustep-base -L $(GNUSTEP_LIB)
endif

dynamic: $(DYNAMIC_LIB)

$(DYNAMIC_LIB): $(OBJS)
	$(CC) -shared -o $(DYNAMIC_LIB) $(OBJS)

static: $(STATIC_LIB)

static: $(STATIC_LIB)

$(STATIC_LIB): $(OBJS)
ifeq ($(detected_OS),Darwin)
	libtool -o $(STATIC_LIB) $(OBJS)
else
	$(AR) rcs -o $(STATIC_LIB) $(OBJS)
endif

%.o:%.m
ifeq ($(detected_OS),Darwin)
ifeq (dynamic,$(MAKECMDGOALS))
	$(CC) -fPIC -std=c11 -c $< -o $@ $(CFLAGS) \
		-fconstant-string-class=NSConstantString
else
	$(CC) -std=c11 -c $< -o $@ $(CFLAGS) \
		-fconstant-string-class=NSConstantString
endif
else
ifeq (dynamic,$(MAKECMDGOALS))
	$(CC) -fPIC -std=c11 -c $< -o $@ $(CFLAGS) \
		$(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
else
	$(CC) -std=c11 -c $< -o $@ $(CFLAGS) \
		$(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
endif
endif
		
clean:
	$(RM) $(TARGET) $(DYNAMIC_LIB) $(STATIC_LIB) $(TARGET_OBJS) $(OBJS)
