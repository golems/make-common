## Shared Makefile to build 3rdparty libs via autotools
##
## -- BEGIN EXAMPLE --
##
## # Package name
## MC3_PACKAGE := llvm
##
## # Package Version
## MC3_VERSION := 2.8
##
## # URL to download package from
## MC3_URL := http://llvm.org/releases/2.8/llvm-2.8.tgz
##
## # Other packages we depend on
## MC3_DEPENDS := build-essential
##
## # Who to call when things break
## MC3_MAINTAINER := George P. Burdell
##
## # Description of the package
## MC3_DESCRIPTION := "Low-Level Virtual Machine (LLVM) compiler"
##
## # Now include the shared makefile
## include /usr/share/make-common/common-3auto.mk
##
## # And now you just type make and it'll spit out a deb
## -- END EXAMPLE --

MC3_MAINTAINER ?= unknown
MC3_DESCRIPTION ?= empty
MC3_DEBVERSION ?= 1

MC3_DEPENDS ?=

ifndef MC3_TARBALL
MC3_TARBALL ?= $(shell basename $(MC3_URL))
endif

ifndef MC3_SRCDIR
MC3_SRCDIR ?= $(shell echo $(MC3_TARBALL) | sed -e 's!\.[^\.]*$$!!; s!\.tar$$!!')
endif

ifndef MC3_CONFIGURE_PREFIX
MC3_CONFIGURE_PREFIX := `pwd`/../debian/usr
endif

ifdef MC3_INSTALL_PREFIX
MC3_INSTALL_PREFIX_FLAG = prefix=$(MC3_INSTALL_PREFIX)
endif

MC3_DEB := $(MC3_PACKAGE)_$(MC3_VERSION)-$(MC3_DEBVERSION).deb


$(MC3_DEB): $(MC3_SRCDIR) debian/DEBIAN/control
	mkdir -p ./debian/usr
	cd $< && ./configure --prefix=$(MC3_CONFIGURE_PREFIX) $(MC3_CONFIGURE_FLAGS)
	cd $< && make
	cd $< && make $(MC3_INSTALL_PREFIX_FLAG) install
	fakeroot dpkg-deb --build debian ./$@

.PHONY: vars

vars:
	@echo MC3_URL: "$(MC3_URL)"
	@echo MC3_TARBALL: "$(MC3_TARBALL)"
	@echo MC3_SRCDIR: "$(MC3_SRCDIR)"
	@echo MC3_DEB: "$(MC3_DEB)"

$(MC3_TARBALL):
	wget -c $(MC3_URL)

$(MC3_SRCDIR): $(MC3_TARBALL)
	tar xavf $(MC3_TARBALL)


debian/DEBIAN/control: Makefile
	mkdir -p debian/DEBIAN
	echo Package: $(MC3_PACKAGE) > $@
	echo Version: $(MC3_VERSION)-$(MC3_DEBVERSION) >> $@
	echo Architecture: `uname -m | sed -e 's/i686/i386/; s/x86_64/amd64/'` >> $@
	echo Maintainer: $(MC3_MAINTAINER) >> $@
	echo Description: $(MC3_DESCRIPTION) >> $@
	echo Depends: $(MC3_DEPENDS) >> $@


clean:
	rm -rf debian  $(MC3_SRCDIR) *.deb

realclean:  clean
	rm -rf debian  $(MC3_TARBALL)
