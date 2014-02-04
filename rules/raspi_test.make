# -*-makefile-*-
#
# Copyright (C) 2014 by Tim Sander <tim01@iss.tu-darmstadt.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_RASPI_TEST) += raspi_test

#
# Paths and names
#
ifdef PTXCONF_RASPI_TEST_TRUNK
RASPI_TEST_VERSION	:= trunk
else
RASPI_TEST_VERSION	:= 0.2
RASPI_TEST_MD5		:=
endif
RASPI_TEST		:= raspi_test-$(RASPI_TEST_VERSION)
RASPI_TEST_URL		:= file://$(PTXDIST_WORKSPACE)/local_src/$(RASPI_TEST)
RASPI_TEST_DIR		:= $(BUILDDIR)/$(RASPI_TEST)
RASPI_TEST_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(RASPI_TEST_SOURCE):
#	@$(call targetinfo)
#	@$(call get, RASPI_TEST)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#RASPI_TEST_CONF_ENV	:= $(CROSS_ENV)

#
# cmake
#
RASPI_TEST_CONF_TOOL	:= cmake
RASPI_TEST_CONF_OPT	:= $(CROSS_CMAKE_USR) -DCMAKE_FIND_ROOT_PATH=$(SYSROOT) -Draspicam_DIR=$(SYSROOT)/usr/lib/cmake -DCMAKE_INSTALL_ALWAYS=true

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/raspi_test.targetinstall:
	@$(call targetinfo)

	@$(call install_init, raspi_test)
	@$(call install_fixup, raspi_test, PRIORITY, optional)
	@$(call install_fixup, raspi_test, SECTION, base)
	@$(call install_fixup, raspi_test, AUTHOR, "Tim Sander <tim01@iss.tu-darmstadt.de>")
	@$(call install_fixup, raspi_test, DESCRIPTION, missing)

#	# copy all binaries
	@for i in $(shell cd $(RASPI_TEST_PKGDIR) && find usr/bin -type f); do \
		$(call install_copy, raspi_test, 0, 0, 0755, -, /$$i); \
	done

	@$(call install_finish, raspi_test)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/raspi_test.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, RASPI_TEST)

# vim: syntax=make
