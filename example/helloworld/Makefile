# Project Name
PROJECT := helloworldexample

# Project Version
VERSION := 1.0

# root to install to for `make install'
PREFIX := /usr/local

# Directory containing C/C++ headers
INCLUDEDIR := .

# Binary Files
BINFILES := helloworldexample

# Library files
LIBFILES := libhelloworldexample.so

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

cc := gcc
ld := ld
LDFLAGS := -shared

include /usr/local/share/make-common/common.1.mk


helloworldexample: hello.o main.o
	gcc hello.o main.o -o $@

hello.o: hello.c helloworldexample.h
	gcc -c $<

main.o: main.c helloworldexample.h
	gcc -c $<

$(eval $(call LINKLIB, libhelloworldexample.so, hello.o))

clean:
	rm -rvf *.o *.so $(BINFILES) dist *.tar.lzma
