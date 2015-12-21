# -*-makefile-*-
#
# Copyright (C) 2015 by Tim Sander <tim@krieglstein.org>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBBCM2835) += libbcm2835

#
# Paths and names
#
LIBBCM2835_VERSION	:= 1.48
LIBBCM2835			:= bcm2835-$(LIBBCM2835_VERSION)
LIBBCM2835_SUFFIX	:= tar.gz
LIBBCM2835_URL		:= http://www.airspayce.com/mikem/bcm2835/bcm2835-$(BCM2835_VERSION).$(BCM2835_SUFFIX)
#BCM2835_URL		:= file://$(PTXDIST_WORKSPACE)/local_src/bcm2835
LIBBCM2835_DIR		:= $(BUILDDIR)/$(LIBBCM2835)
LIBBCM2835_SOURCE	:= $(SRCDIR)/$(LIBBCM2835).$(LIBBCM2835_SUFFIX)
LIBBCM2835_BUILD_OOT	:= YES
LIBBCM2835_LICENSE	:= GPL v2

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

$(STATEDIR)/libbcm2835.extract: $(STATEDIR)/autogen-tools

$(STATEDIR)/libbcm2835.extract:
	@$(call targetinfo)
	@$(call clean, $(LIBBCM2835_DIR))
	@$(call extract, LIBBCM2835)
	cd $(LIBBCM2835_DIR) && [ -f configure ] || sh autogen.sh
	@$(call patchin, LIBBCM2835)
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

LIBBCM2835_CONF_ENV	:= $(CROSS_ENV)

#
# autoconf
#
LIBBCM2835_CONF_TOOL	:= autoconf
#LIBBCM2835_CONF_OPT	:= $(CROSS_AUTOCONF_USR)

#$(STATEDIR)/libbcm2835.prepare:
#	@$(call targetinfo)
#	@$(call world/prepare, LIBBCM2835)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

#$(STATEDIR)/libbcm2835.compile:
#	@$(call targetinfo)
#	@$(call world/compile, LIBBCM2835)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libbcm2835.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBBCM2835)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/libbcm2835.targetinstall:
	@$(call targetinfo)

	@$(call install_init, libbcm2835)
	@$(call install_fixup, libbcm2835, PRIORITY, optional)
	@$(call install_fixup, libbcm2835, SECTION, base)
	@$(call install_fixup, libbcm2835, AUTHOR, "Tim Sander <tim@krieglstein.org>")
	@$(call install_fixup, libbcm2835, DESCRIPTION, missing)

#	#
#	# example code:; copy all libraries, links and binaries
#	#

	@for i in $(shell cd $(LIBBCM2835_PKGDIR) && find bin sbin usr/bin usr/sbin -type f); do \
		$(call install_copy, libbcm2835, 0, 0, 0755, -, /$$i); \
	done
	@for i in $(shell cd $(LIBBCM2835_PKGDIR) && find lib usr/lib -name "*.so*"); do \
		$(call install_copy, libbcm2835, 0, 0, 0644, -, /$$i); \
	done
	@links="$(shell cd $(LIBBCM2835_PKGDIR) && find lib usr/lib -type l)"; \
	if [ -n "$$links" ]; then \
		for i in $$links; do \
			from="`readlink $(LIBBCM2835_PKGDIR)/$$i`"; \
			to="/$$i"; \
			$(call install_link, libbcm2835, $$from, $$to); \
		done; \
	fi

#	#
#	# FIXME: add all necessary things here
#	#

	@$(call install_finish, libbcm2835)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/libbcm2835.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, LIBBCM2835)

# vim: syntax=make
