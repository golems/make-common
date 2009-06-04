## FILE: common.1.mk
## AUTHOR: Neil Dantam
##
## Some common routines for makefiles

## USAGE:
#
# Set the following environtment variables
#
# # Project Name
# PROJECT := helloworld
#
# # Project Version
# VERSION := 0.0
#
# # root to install to for `make install'
# PREFIX := /usr/local
#
# # Directory containing C/C++ headers
# INCLUDEDIR := .
#
# # Binary Files
# BINFILES := helloexample
#
# # Library files
# LIBFILES := libhelloexample.so
#
# # Directory of files (or links to files) to copy verbatim
# VERBATIMDIR := verbatim
#
# # if you use stow, root of your stow package directory
# STOWBASE := /usr/local/stow
#
# # Files to tar up for distribution
# DISTFILES := hello.c hello.h
#
# # Path to copy distribution tarball
# DISTPATH := $(HOME)/prism/tarballs
#
# # Path to copy HTML Doxygen documentation
# DOXPATH := $(HOME)/prism/public_html/dox
#
# # Compiler and linker to use
# cc := gcc
# f95 := gfortran
# ld := ld


PROJVER := $(PROJECT)-$(VERSION)

STOWDIR := $(PROJVER)
STOWPREFIX := $(STOWBASE)/$(STOWDIR)


define LINKLIB
$(1): $(2)
	$(ld) $(LDFLAGS) -o $(1) $(2)
endef

default: $(BINFILES) $(LIBFILES)

TERM_GREEN="\033[0;32m"
TERM_NO_COLOR="\033[0m"
TERM_LIGHT_GREEN="\033[1;32m"


stow: default
	@echo $(TERM_LIGHT_GREEN)'* INSTALLING BINARIES *'$(TERM_NO_COLOR)
	if test -n "$(BINFILES)"; then \
		mkdir -p $(STOWPREFIX)/bin; \
		install --mode 755 $(BINFILES) $(STOWPREFIX)/bin; \
	fi
	@echo $(TERM_LIGHT_GREEN)'* INSTALLING LIBS *'$(TERM_NO_COLOR)
	if test -n "$(LIBFILES)"; then \
		mkdir -p $(STOWPREFIX)/lib; \
		install --mode 755 $(LIBFILES) $(STOWPREFIX)/lib; \
	fi
	@echo $(TERM_LIGHT_GREEN)'* INSTALLING HEADERS *'$(TERM_NO_COLOR)
	if test -n "$(INCLUDEDIR)"; then \
		mkdir -p $(STOWPREFIX)/include; \
		cd $(INCLUDEDIR) && \
		install --mode 644 `find -regex '^.*\.h'`\
		  $(STOWPREFIX)/include; \
	fi
	@echo $(TERM_LIGHT_GREEN)'* INSTALLING VERBATIM *'$(TERM_NO_COLOR)
	if test -n "$(VERBATIMDIR)"; then \
		mkdir -p $(STOWPREFIX); \
		cp -TLr $(VERBATIMDIR) $(STOWPREFIX); \
	fi
	@echo $(TERM_LIGHT_GREEN)'* STOWING *'$(TERM_NO_COLOR)
	cd $(STOWBASE) && stow $(STOWDIR)


## Developer targets

docul: doc
	cp -Tr doc/html $(DOXPATH)/$(PROJECT)

dist: $(DISTFILES)
	mkdir -p dist/$(PROJVER)
	@echo $(TERM_LIGHT_GREEN)'* MAKING DIRECTORY TREE *'$(TERM_NO_COLOR)
	find $(DISTFILES) '!' -path '*/.svn/*' \
	  '!' -path '*/.svn' \
	  -type d \
	  -exec mkdir -vp dist/$(PROJVER)/'{}' ';'
	@echo $(TERM_LIGHT_GREEN)'* LINKING REAL FILES *'$(TERM_NO_COLOR)
	find $(DISTFILES) '!' -path '*/.svn/*'  -type f \
	  -exec ln -v '{}' dist/$(PROJVER)/'{}' ';'
	@echo $(TERM_LIGHT_GREEN)'* COPYING SYMLINKS *'$(TERM_NO_COLOR)
	find $(DISTFILES) '!' -path '*/.svn/*'  -type l \
	  -exec cp -Pv '{}' dist/$(PROJVER)/'{}' ';'
	@echo $(TERM_LIGHT_GREEN)'* TARRING IT UP *'$(TERM_NO_COLOR)
	cd dist &&               \
	tar  --lzma -cvf $(DISTPATH)/$(PROJVER).tar.lzma $(PROJVER)
