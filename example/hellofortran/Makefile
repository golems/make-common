# Project Name
PROJECT := helloworldexample

# Project Version
VERSION := 1.0

# root to install to for `make install'
PREFIX := /usr/local

# Directory containing C/C++ headers
INCLUDEDIR := .

# Binary Files
BINFILES := hellofortranexample

# Library files
LIBFILES := libhellofortranexample.so

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



include /usr/local/share/make-common/common.1.mk



hellofortranexample: main.o hellof.o
	gcc hellof.o main.o -o $@ -lgfortran

hellof.o: hellof.f95
	gfortran -c $<

main.o: main.c hellofortranexample.h
	gcc -c $<

$(eval $(call LINKLIB, libhellofortranexample.so, hellof.o))

clean:
	rm -rvf *.o *.so $(BINFILES) dist *.tar.lzma *.mod
