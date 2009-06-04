# Project Name
PROJECT := helloworldexample

# Project Version
VERSION := 1.0

# root to install to for `make install'
PREFIX := /usr/local

# Directory containing C/C++ headers
INCLUDEDIR := .

# Binary Files
BINFILES := hellofortranexample.exe

# Library files
LIBFILES :=

# Directory of files and links to copy verbatim
#VERBATIMDIR := verbatim

# if you use stow, root of your stow package directory
STOWBASE := /usr/local/stow

# Files to tar up for distribution
DISTFILES := Makefile hello.c helloworldexample.h

# Path to copy distribution tarball
DISTPATH := $(PWD)

# Path to copy HTML Doxygen documentation
#DOXPATH := $(HOME)/prism/public_html/dox





f95 := wine "c:\Program Files\gfortran\bin\gfortran.exe"
cc := wine "c:\Program Files\gfortran\bin\gcc.exe"

ld := wine "c:\Program Files\gfortran\bin\ld.exe"

LDFLAGS := -shared
CFLAGS := -I"c:\Program Files\gfortran\include"

include /usr/local/share/make-common/common.1.mk

hellofortranexample.exe: main.o hellof.o
	$(cc) hellof.o main.o -o $@ -lgfortran

hellof.o: hellof.f95
	$(f95) -c $<

main.o: main.c hellofortranexample.h
	$(cc) $(CFLAGS) -c $<

$(eval $(call LINKLIB, libhellofortranexample.dll, hellof.o))

clean:
	rm -rvf *.o *.so $(BINFILES) dist *.tar.lzma *.mod *.exe
