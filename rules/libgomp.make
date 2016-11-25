# -*-makefile-*-
#
# Copyright (C) 2016 by Tim Sander
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_LIBGOMP) += libgomp

#
# Paths and names
#
LIBGOMP_VERSION	:= 1.0.0
LIBGOMP_MD5		:=
LIBGOMP			:= libgomp-$(LIBGOMP_VERSION)
#LIBGOMP_URL		:= file://local_src/libgomp
#LIBGOMP_DIR		:= $(BUILDDIR)/$(LIBGOMP)
LIBGOMP_LICENSE	:= unknown

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

#$(STATEDIR)/libgomp.extract:
#	@$(call targetinfo)
#	@$(call clean, $(LIBGOMP_DIR))
#	@$(call extract, LIBGOMP)
#	@$(call patchin, LIBGOMP)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#LIBGOMP_PATH	:= PATH=$(CROSS_PATH)
LIBGOMP_CONF_TOOL	:= NO
LIBGOMP_MAKE_ENV	:= $(CROSS_ENV)

#$(STATEDIR)/libgomp.prepare:
#	@$(call targetinfo)
#	@$(call world/prepare, LIBGOMP)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

$(STATEDIR)/libgomp.compile:
	@$(call targetinfo)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

#$(STATEDIR)/libgomp.install:
#	@$(call targetinfo)
#	@$(call world/install, LIBGOMP)
#	@$(call touch)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

#TOOLCHAIN_SYSROOT := $(shell symlinks $(PTXDIST_WORKSPACE) |grep selected_toolchain|awk '{print $$4"/../sysroot-*"}'")
TOOLCHAIN_SYSROOT := $(shell symlinks $(PTXDIST_WORKSPACE) |grep selected_toolchain|awk '{print $$4"/../sysroot-*"}')
LIBGOMPPATH1 := $(shell find $(TOOLCHAIN_SYSROOT) -name libgomp.so)
$(STATEDIR)/libgomp.targetinstall:
	@$(call targetinfo)
	@$(call install_init, libgomp)
	@$(call install_fixup, libgomp,PRIORITY,optional)
	@$(call install_fixup, libgomp,SECTION,base)
	@$(call install_fixup, libgomp,AUTHOR,"Tim Sander")
	@$(call install_fixup, libgomp,DESCRIPTION,missing)
	@$(call install_copy, libgomp, 0, 0, 0755, $(LIBGOMPPATH1).1.0.0, /usr/lib/libgomp.so.1.0.0)
	@$(call install_link, libgomp, libgomp.so.1.0.0, /usr/lib/libgomp.so.1.0)
	@$(call install_link, libgomp, libgomp.so.1.0.0, /usr/lib/libgomp.so.1)
	@$(call install_link, libgomp, libgomp.so.1.0.0, /usr/lib/libgomp.so)
	@$(call install_finish, libgomp)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

$(STATEDIR)/libgomp.clean:
	@$(call targetinfo)
	@-cd $(LIBGOMP_DIR) && \
		$(LIBGOMP_ENV) $(LIBGOMP_PATH) $(MAKE) clean
	@$(call clean_pkg, LIBGOMP)

# vim: syntax=make
