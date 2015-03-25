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
PACKAGES-$(PTXCONF_RASPICAM) += raspicam

#
# Paths and names
#
ifdef PTXCONF_RASPICAM_TRUNK
RASPICAM_VERSION	:= trunk
else
RASPICAM_VERSION	:= 0.1.3
RASPICAM_MD5		:= 1c6fef67aeaa7828bcde899e9873986e
endif
RASPICAM		:= raspicam-$(RASPICAM_VERSION)
RASPICAM_SUFFIX		:= zip
RASPICAM_URL		:= http://sourceforge.net/projects/raspicam/files/$(RASPICAM).$(RASPICAM_SUFFIX)/download
RASPICAM_SOURCE		:= $(SRCDIR)/$(RASPICAM).$(RASPICAM_SUFFIX)
RASPICAM_DIR		:= $(BUILDDIR)/$(RASPICAM)
RASPICAM_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(RASPICAM_SOURCE):
#	@$(call targetinfo)
#	@$(call get, RASPICAM)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#RASPICAM_CONF_ENV	:= $(CROSS_ENV)

#
# cmake
#
RASPICAM_CONF_TOOL	:= cmake
RASPICAM_CONF_OPT	:= $(CROSS_CMAKE_USR)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/raspicam.targetinstall:
	@$(call targetinfo)

	@$(call install_init, raspicam)
	@$(call install_fixup, raspicam, PRIORITY, optional)
	@$(call install_fixup, raspicam, SECTION, base)
	@$(call install_fixup, raspicam, AUTHOR, "Tim Sander <tim@krieglstein.org>")
	@$(call install_fixup, raspicam, DESCRIPTION, missing)

	$(call install_lib, raspicam, 0, 0, 0644, libraspicam);
	$(call install_lib, raspicam, 0, 0, 0644, libraspicam_cv);

	@$(call install_finish, raspicam)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/raspicam.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, RASPICAM)

# vim: syntax=make
