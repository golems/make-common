# Project Name
PROJECT := helloworldexample

# Project Version
VERSION := 1.0

# Directory containing C/C++ headers
INCLUDEDIR := .

# Binary Files
BINFILES := hellofortranexample.exe

# Library files
LIBFILES := libhellofortranexample.a

# Files to tar up for distribution
DISTFILES := Makefile hello.c helloworldexample.h

# Path to copy distribution tarball
DISTPATH := $(PWD)

# Path to copy HTML Doxygen documentation
#DOXPATH := $(HOME)/prism/public_html/dox





f95 := wine "c:\Program Files\gfortran\bin\gfortran.exe"
cc := wine "c:\Program Files\gfortran\bin\gcc.exe"
ld := wine "c:\Program Files\gfortran\bin\ld.exe"
ar := wine "c:\Program Files\gfortran\bin\ar.exe"

LDFLAGS := -shared


hellofortranexample.exe: main.o libhellofortranexample.a
	$(cc) main.o -L. -lhellofortranexample -o $@ -lgfortran

include /usr/local/share/make-common/common.1.mk

libhellofortranexample.a: hellof.o
	$(ar) rcs $@ $<


$(eval $(call LINKLIB, libhellofortranexample.dll, hellof.o))

clean:
	rm -rvf *.o *.so $(BINFILES) dist *.tar.lzma *.mod *.exe
