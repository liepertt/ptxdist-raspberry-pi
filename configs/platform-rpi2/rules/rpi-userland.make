# -*-makefile-*-
#
# Copyright (C) 2013 by Tim Sander <tim@krieglstein.org>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_RPI_USERLAND) += rpi-userland

#
# Paths and names
#
#RPI_USERLAND_VERSION	:= 8b271ac
#RPI_USERLAND_MD5		:= 23d2ed4cb9098e7d7968f3f83db3175c
RPI_USERLAND_VERSION	:= 0de0b205ea
RPI_USERLAND_MD5		:= 942aab008ad18348c8ec5949303d7633
RPI_USERLAND			:= rpi-userland-$(RPI_USERLAND_VERSION)
RPI_USERLAND_URL		:= http://github.com/raspberrypi/userland/tarball/$(RPI_USERLAND_VERSION)
RPI_USERLAND_DIR		:= $(BUILDDIR)/$(RPI_USERLAND)
RPI_USERLAND_SUFFIX		:= .tar.gz
RPI_USERLAND_SOURCE		:= $(SRCDIR)/$(RPI_USERLAND).$(RPI_USERLAND_SUFFIX)
RPI_USERLAND_LICENSE	:= BSD-3c

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(RPI_USERLAND_SOURCE):
#	@$(call targetinfo)
#	@$(call get, RPI_USERLAND)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#RPI_USERLAND_CONF_ENV	:= $(CROSS_ENV)

#
# cmake
#
RPI_USERLAND_CONF_TOOL	:= cmake
RPI_USERLAND_CONF_OPT   := \
	-DVMCS_INSTALL_PREFIX=/usr\
	-DCMAKE_INSTALL_PREFIX=/usr\
	-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
	-DCMAKE_TOOLCHAIN_FILE='${PTXDIST_CMAKE_TOOLCHAIN_TARGET}' 

#RPI_USERLAND_CONF_OPT   := $(CROSS_CMAKE_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/rpi-userland.targetinstall:
	@$(call targetinfo)

	@$(call install_init, rpi-userland)
	@$(call install_fixup, rpi-userland, PRIORITY, optional)
	@$(call install_fixup, rpi-userland, SECTION, base)
	@$(call install_fixup, rpi-userland, AUTHOR, "Tim Sander <tim@krieglstein.org>")
	@$(call install_fixup, rpi-userland, DESCRIPTION, missing)

	@for i in $(shell cd $(RPI_USERLAND_PKGDIR) && find opt/vc/sbin -type f); do \
		$(call install_copy, rpi-userland, 0, 0, 0755, $(RPI_USERLAND_PKGDIR)/$$i, /usr/sbin/$$(basename $$i)); \
	done
	@for i in $(shell cd $(RPI_USERLAND_PKGDIR) && find opt/vc/bin -type f); do \
		$(call install_copy, rpi-userland, 0, 0, 0755, $(RPI_USERLAND_PKGDIR)/$$i, /usr/bin/$$(basename $$i)); \
	done
	@for i in $(shell cd $(RPI_USERLAND_PKGDIR) && find opt/vc/lib -name "*.so*"); do \
		$(call install_copy, rpi-userland, 0, 0, 0644, $(RPI_USERLAND_PKGDIR)/$$i, /usr/lib/$$(basename $$i)); \
	done
	@links="$(shell cd $(RPI_USERLAND_PKGDIR) && find lib opt/vc/lib -type l)"; \
	if [ -n "$$links" ]; then \
		for i in $$links; do \
			from="`readlink $(RPI_USERLAND_PKGDIR)/$$i`"; \
			to="/usr/lib/$$(basename $$i)"; \
			$(call install_link, rpi-userland, $$from, $$to); \
		done; \
	fi

	@$(call install_finish, rpi-userland)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/rpi-userland.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, RPI_USERLAND)

# vim: syntax=make
