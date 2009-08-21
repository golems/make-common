## A makefile demostrating that fortran compilation "Just Works"
## Also shows linking against a static and shared library


# Project Name
PROJECT := helloworldexample

# Project Version
VERSION := 1.0

# Binary Files
BINFILES := hellofortranexample

# Library files
SHAREDLIBS := hellofortranexample


default: all

include ../../common.1.mk

all: $(BINFILES) $(LIBFILES)

# target to link our binary agains shared libgfortran.so and static hellofortranexample.a
$(call LINKBIN, hellofortranexample, main.o, gfortran, hellofortranexample)

libhellofortranexample.a: hellof.o
	$(ar) rcs $@ $<

# make a shared library, just for kicks
$(call LINKLIB, hellofortranexample, hellof.o)

clean:
	rm -rvf *.o *.so $(BINFILES) dist *.tar.lzma *.mod *.a
