# Project Name
PROJECT := make-common

# Project Version
VERSION := 1.0

# Files to tar up for distribution
DISTFILES := common.1.mk Makefile verbatim README example

# Path to copy distribution tarball
DISTPATH := $(PWD)

# Path to copy HTML Doxygen documentation
#DOXPATH := $(HOME)/prism/public_html/dox

INCLUDEDIR := /dev/null

include ./common.1.mk

clean:
	rm -rfv *.tar.lzma dist
