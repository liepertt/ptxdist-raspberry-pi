# -*-makefile-*-
#
# Copyright (C) 2015 by <tim@krieglstein.org>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_K6RSS) += k6rss

#
# Paths and names
#
K6RSS_VERSION	:= 0.1
K6RSS		:= k6rss-$(K6RSS_VERSION)
K6RSS_URL	:= file://$(PTXDIST_WORKSPACE)/local_src/info_screen/rss
K6RSS_DIR	:= $(BUILDDIR)/$(K6RSS)
K6RSS_BUILD_OOT	:= YES
K6RSS_LICENSE	:= GPLV3

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(K6RSS_SOURCE):
#	@$(call targetinfo)
#	@$(call get, K6RSS)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#K6RSS_CONF_ENV	:= $(CROSS_ENV)

#
# qmake
#
K6RSS_CONF_TOOL	:= qmake
K6RSS_CONF_OPT	:= $(CROSS_QMAKE_OPT) PREFIX=/usr

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

$(STATEDIR)/k6rss.targetinstall:
	@$(call targetinfo)

	@$(call install_init, k6rss)
	@$(call install_fixup, k6rss, PRIORITY, optional)
	@$(call install_fixup, k6rss, SECTION, base)
	@$(call install_fixup, k6rss, AUTHOR, "<tim@krieglstein.org>")
	@$(call install_fixup, k6rss, DESCRIPTION, missing)

#	#
#	# example code:; copy all binaries
#	#

#	@for i in $(shell cd $(K6RSS_PKGDIR) && find bin sbin usr/bin usr/sbin -type f); do \
#		$(call install_copy, k6rss, 0, 0, 0755, -, /$$i); \
#	done
	$(call install_copy, k6rss, 0, 0, 0755, $(K6RSS_DIR)-build/qt-gui, /usr/bin/k6rss); 

#	#
#	# FIXME: add all necessary things here
#	#

	@$(call install_finish, k6rss)

	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/k6rss.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, K6RSS)

# vim: syntax=make
