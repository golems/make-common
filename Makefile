PROJECT := make-common

VERSION := 1.6.7

INCLUDEDIR := .not
SRCDIR := .not

default:
	@echo "nothing to build"

include ./common.1.mk


clean:
	rm -rfv *.tar.* dist *.deb .dep debian $(PROJECT)-$(VERSION)
