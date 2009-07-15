## FILE: common.1.mk
## AUTHOR: Neil Dantam
##
## Some common routines for makefiles
##
## Almost surely requires gmake.
## You should use a GNU userland.


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
# # Binary Files
# BINFILES := helloexample
#
# # Library files
# LIBFILES := libhelloexample.so
#
# # Files to tar up for distribution
# DISTFILES := hello.c hello.h
#
# # Path to copy distribution tarball
# DISTPATH := $(HOME)/prism/tarballs
#
# # Path to copy HTML Doxygen documentation
# DOXPATH := $(HOME)/prism/public_html/dox


#######################
## DEFAULT VARIABLES ##
#######################

## Override these prior to the include as desired

## define compilers

# C Compiler
ifndef cc
cc := gcc
endif

# C++ Compiler
ifndef CC
CC = g++
endif

# Fortran 95 Compiler
ifndef f95
f95 := gfortran
endif


# Objective C Compiler
ifndef objcc
objcc := gcc
endif

# Static Libary Linker
ifndef ar
ar := ar
endif

# Linker
ifndef ld
ld := ld
endif

## default directories

ifndef INCLUDEDIR
# ./include if it exists, else .
INCLUDEDIR := $(shell if [ -d ./include ]; then echo ./include; else echo .; fi)
endif

ifndef SRCDIR
# ./src if it exists, else .
SRCDIR := $(shell if [ -d ./src ]; then echo ./src; else echo .; fi)
endif


ifndef BUILDDIR
# ./src if it exists, else .
BUILDDIR := $(shell if [ -d ./build ]; then echo ./build; else echo .; fi)
endif

ifndef LIBDIR
# ./src if it exists, else .
LIBDIR := $(shell if [ -d $(BUILDDIR)/lib ]; then echo $(BUILDDIR)/lib; else echo $(BUILDDIR); fi)
endif

ifndef BINDIR
# ./src if it exists, else .
BINDIR := $(shell if [ -d $(BUILDDIR)/bin ]; then echo $(BUILDDIR)/bin; else echo $(BUILDDIR); fi)
endif

ifndef LIBDIRS
LIBDIRS = $(LIBDIR)
endif

ifndef PREFIX
PREFIX := /usr/local
endif

## default compiler flags

# C
ifndef CFLAGS
CFLAGS := -g -I$(INCLUDEDIR)
endif

# C++
ifndef CPPFLAGS
CPPFLAGS = $(CFLAGS)
endif


# Objective-C
ifndef OBJCFLAGS
OBJCFLAGS = $(CFLAGS)
endif


# Fortran
ifndef FFLAGS
FFLAGS := -g -J$(INCLUDEDIR)
endif

# Linker
ifndef LDFLAGS
LDFLAGS := -shared
endif

## default source files

ifndef SRCFILES
SRCFILES := $(shell find .  \( -type d \( -name .svn -o -name .git \)  -prune \)  -o -regex '.*\.\(c\|cpp\|f95\)' -print)
# Maybe svn list -R | egrep '^.*\.(c|cpp|f95)$'
# It would be nicer (40x) on a cold disk cache, but slower (4x) otherwise
# Would also fail if files are not yet svn add'ed
endif

ifndef VERBATIMDIR
VERBATIMDIR := verbatim
endif

# if you use stow, root of your stow package directory
ifndef STOWBASE
STOWBASE := $(PREFIX)/stow
endif

comma := ,

PROJVER := $(PROJECT)-$(VERSION)

STOWDIR := $(PROJVER)
STOWPREFIX := $(STOWBASE)/$(STOWDIR)
DEPDIR := .deps


## Dependency Files
## (gcc will generate dependency info for C and C++ files and spit out make rules)
## We use one dep file for each source file to minimize dependency regenerations
DEPFILES := $(addprefix $(DEPDIR)/,$(addsuffix .d, $(filter %.c %.cpp, $(SRCFILES))))

#####################
## FIXUP VARIABLES ##
#####################

LIBFILES := $(addprefix $(LIBDIR)/, $(LIBFILES))
BINFILES := $(addprefix $(BINDIR)/, $(BINFILES))

#######################
## PORTABILITY TESTS ##
#######################

## OS X uses a different library extension, play nice
ifeq ($(PLATFORM),Darwin)
# somebody who can actually stomach "The Apple Way" should test this...
SHARED_LIB_SUFFIX := .dylib
LDFLAGS := -lc
else
SHARED_LIB_SUFFIX := .so
endif




#############
## TARGETS ##
#############

## Target to print out the defined variables
env:
	@echo PROJECT: $(PROJECT)
	@echo VERSION: $(VERSION)
	@echo PREFIX: $(PREFIX)
	@echo SRCDIR: $(SRCDIR)
	@echo INCLUDEDIR: $(INCLUDEDIR)
	@echo BUILDDIR: $(BUILDDIR)
	@echo LIBDIR: $(LIBDIR)
	@echo BINDIR: $(BINDIR)
	@echo PLATFORM: $(PLATFORM)
	@echo cc: $(cc)
	@echo CC: $(CC)
	@echo f95: $(f95)
	@echo objcc: $(objcc)
	@echo ld: $(ld)
	@echo ar: $(ar)
	@echo CFLAGS: $(CFLAGS)
	@echo CPPFLAGS: $(CPPFLAGS)
	@echo OBJCFLAGS: $(OBJCFLAGS)
	@echo FFLAGS: $(FFLAGS)
	@echo LDFLAGS: $(LDFLAGS)
	@echo SRCFILES: $(SRCFILES)
	@echo OBJFILES: $(OBJFILES)
	@echo DEPFILES: $(DEPFILES)
	@echo LIBFILES: $(LIBFILES)
	@echo BINFILES: $(BINFILES)
	@echo SHARED_LIB_SUFFIX: $(SHARED_LIB_SUFFIX)




## Include the auto-generated dependencies
-include $(DEPFILES)




#####################
## DEFAULT TARGETS ##
#####################

## These create targets to build C, C++, Fortran, and Objective C

$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -vp $(dir $(@))
	$(cc) $(CFLAGS) -c $< -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -vp $(dir $(@))
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.cc
	@mkdir -vp $(dir $(@))
	$(CC) $(CPPFLAGS) -c $< -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.f95
	@mkdir -vp $(dir $(@))
	$(f95) -J$(INCLUDEDIR) -c $< -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.m
	@mkdir -vp $(dir $(@))
	$(objcc) $(OBJCFLAGS) -c $< -o $@

## Rules to generate dependecy info
## Hopefully gfortran will do this too, soon

$(DEPDIR)/%.c.d: $(SRCDIR)/%.c
	@mkdir -pv $(dir $@)
	echo -n $(dir $<)  > $@
	$(cc) $(CFLAGS) -MM  $< >> $@

$(DEPDIR)/%.cpp.d: $(SRCDIR)/%.cpp
	echo -n $(dir $<)  > $@
	$(CC) $(CPPFLAGS) -MM  $< >> $@


## Convenience method for linking shared libraries
## For some reason, automatic variables don't work here...
## call with  $(call LINKLIB, name_of_lib, list of object files)
## ie with $(call LINKLIB, frob, foo.o bar.o) # gives libfrob.so
define LINKLIB1
$(LIBDIR)/lib$(strip $(1))$(SHARED_LIB_SUFFIX): $(2)
	$(ld) $(LDFLAGS) -o $(LIBDIR)/lib$(strip $(1))$(SHARED_LIB_SUFFIX) $(2)
endef

# this def does the eval so the caller doesn't have to
define LINKLIB
$(eval $(call LINKLIB1, $1, $2))
endef

#$(addprefix -llib, $(addsuffix $(4), .a))


## Convenience method for linking binaries
## call with $(call LINKLIB, name_of_binary, object files, shared libs, static libs)
## ie  $(call LINKBIN frob, foo.o, bar, bif)
define LINKBIN1
$(strip $(1)): $(2)  $(addsuffix .a, $(addprefix lib, $(4)))
	$(cc) $(CFLAGS) -o $(strip $(1)) $(2) \
	  $(addprefix -L, $(LIBDIRS))  \
	  $(if $(strip $(4)), -Wl$(comma)-Bstatic) $(addprefix -l, $(strip $(4)))  \
	  $(if $(strip $(3)), -Wl$(comma)-Bdynamic) $(addprefix -l, $(3))
endef

# this def does the eval so the caller doesn't have to
define LINKBIN
$(eval $(call LINKBIN1, $1, $2, $3, $4))
endef

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
