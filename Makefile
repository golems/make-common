# Project Name
PROJECT := make-common

# Project Version
VERSION := 1.3.7

# Files to tar up for distribution
#DISTFILES := common.1.mk Makefile verbatim README example

INCLUDEDIR := /dev/null

# Path to copy distribution tarball
#DISTPATH := $(PWD)

# Path to copy HTML Doxygen documentation
#DOXPATH := $(HOME)/prism/public_html/dox

include ./common.1.mk

clean:
	rm -rfv *.tar.* dist *.deb .dep debian $(PROJECT)-$(VERSION)
