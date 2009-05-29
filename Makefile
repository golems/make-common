# Project Name
PROJECT := make-common

# Project Version
VERSION := 1.0

# root to install to for `make install'
PREFIX := /usr/local

# Directory containing C/C++ headers
HEADERDIR := .

# Binary Files
#BINFILES := helloexample

# Library files
#LIBRARYFILES := libhelloexample.so

# files and links to files to copy verbatim
VERBATIMDIR := verbatim

# if you use stow, root of your stow package directory
STOWBASE := /usr/local/stow

# Files to tar up for distribution
DISTFILES := common.1.mk Makefile verbatim README example

# Path to copy distribution tarball
DISTPATH := $(PWD)

# Path to copy HTML Doxygen documentation
#DOXPATH := $(HOME)/prism/public_html/dox

include ./common.1.mk

clean:
	rm -rfv *.tar.lzma dist
