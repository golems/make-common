## A basic make-common project
## Uses a couple of source files and generates a shared library


# Project Name
PROJECT := helloworldexample

# Project Version
VERSION := 1.0

# Binary Files
BINFILES := helloworldexample

# Library files
SHAREDLIBS := helloworldexample


## define the default target before the include
default: all

include ../../common.1.mk

## use the expanded variables after the include
all: $(LIBFILES) $(BINFILES)


# generate the target to link our binary
$(call LINKBIN, helloworldexample, hello.o main.o)

# generate the target to link our library
$(call LINKLIB, helloworldexample, hello.o)

clean:
	rm -rvf *.o $(LIBFILES) $(BINFILES) dist *.tar.lzma
