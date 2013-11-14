# -*-makefile-*-
#
# Copyright (C) 2008 by Juergen Beisert
#               2009-2011 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_QT5) += qt5

#
# Paths and names
#
QT5_VERSION	:= 5.2.0-beta1
QT5_MD5		:=
QT5		:= qt-everywhere-opensource-src-$(QT5_VERSION)
QT5_SUFFIX	:= tar.xz
#QT5_URL		:= http://download.qt-project.org/official_releases/qt/5.2/${QT_VERSION}/single/$(QT5).$(QT5_SUFFIX)
QT5_URL  := http://download.qt-project.org/development_releases/qt/5.2/5.2.0-beta1/single/qt-everywhere-opensource-src-5.2.0-beta1.tar.xz
QT5_SOURCE	:= $(SRCDIR)/$(QT5).$(QT5_SUFFIX)
QT5_DIR		:= $(BUILDDIR)/$(QT5)
QT5_BUILD_OOT	:= YES
QT5_LICENSE	:= GPL3, LGPLv2.1

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

GLES2_LIBS	:= -lGLESv2 -lnvapputil -lnvavp -lnvcwm -lnvdc -lnvddk_2d -lnvddk_2d_v2 -lnvddk_disp -lnvddk_kbc -lnvddk_mipihsi -lnvddk_nand -lnvddk_se -lnvddk_snor -lnvddk_spif -lnvddk_usbphy -lnvdispatch_helper -lnvglsi -lnvmedia_audio -lnvmm_audio -lnvmm_camera -lnvmm_contentpipe -lnvmm_image -lnvmmlite_audio -lnvmmlite_image -lnvmmlite -lnvmmlite_utils -lnvmmlite_video -lnvmm_manager -lnvmm_parser -lnvmm_service -lnvmm -lnvmm_video -lnvmm_writer -lnvodm_disp -lnvodm_dtvtuner -lnvodm_imager -lnvodm_misc -lnvodm_query -lnvomxilclient -lnvos -lnvparser -lnvrm_graphics -lnvrm -lnvsm -lnvtestio -lnvtestresults -lnvtvmr -lnvwinsys -lardrv_dynamic -lnvmm_utils 

$(STATEDIR)/qt5.extract:
	@$(call targetinfo)
	@$(call clean, $(QT5_DIR))
	@$(call extract, QT5)
	@$(call patchin, QT5)
	@sed -e "s#@PTXDIST_CPPFLAGS@#$(CROSS_CPPFLAGS)#g" \
		 -e "s#@PTXDIST_CFLAGS@#$(CROSS_CFLAGS)#g" \
		 -e "s#@PTXDIST_CXXFLAGS@#$(CROSS_CXXFLAGS)#g" \
	     -e "s#.$$\[QT_SYSROOT\]#$(SYSROOT)#g" $(QT5_DIR)/qtbase/mkspecs/devices/linux-rasp-pi-g++/qmake.conf |sponge $(QT5_DIR)/qtbase/mkspecs/devices/linux-rasp-pi-g++/qmake.conf
#	@for file in $(QT5_DIR)/qtbase/mkspecs/devices/linux-rasp-pi-g++/*.in; do \
#		sed -e "s,@PTXDIST_COMPILER_PREFIX@,$(COMPILER_PREFIX),g" \
#			-e "s#@PTXDIST_QT_QPA_DEFAULT_PLATFORM@#xcb#g" \
#			-e "s#@PTXDIST_CPPFLAGS@#$(CROSS_CPPFLAGS)#g" \
#			-e "s#@PTXDIST_CFLAGS@#$(CROSS_CFLAGS)#g" \
#			-e "s#@PTXDIST_CXXFLAGS@#$(CROSS_CXXFLAGS)#g" \
#			-e "s#@PTXDIST_INCDIR@#$(SYSROOT)/include $(SYSROOT)/usr/include#g" \
#			-e "s#@PTXDIST_LIBDIR@#$(SYSROOT)/lib $(SYSROOT)/usr/lib#g" \
#			-e "s#@PTXDIST_LDFLAGS@#$(strip $(CROSS_LDFLAGS))#g" \
#			-e "s#@PTXDIST_COMPILER_FLAGS@##g" \
#			-e "s#@PTXDIST_QMAKE_CXXFLAGS_RELEASE@#-O3#g" \
#			-e "s#@PTXDIST_QMAKE_LIBS@#-lrt -lpthread -ldl#g" \
#			-e "s#@PTXDIST_QMAKE_INCDIR_EGL@##g" \
#			-e "s#@PTXDIST_QMAKE_LIBDIR_EGL@##g" \
#			-e "s#@PTXDIST_QMAKE_INCDIR_OPENGL_ES2@##g" \
#			-e "s#@PTXDIST_QMAKE_LIBDIR_OPENGL_ES2@##g" \
#			-e "s#@PTXDIST_QMAKE_INCDIR_OPENVG@##g" \
#			-e "s#@PTXDIST_QMAKE_LIBDIR_OPENVG@##g" \
#			-e "s#@PTXDIST_QMAKE_LIBS_EGL@#-lEGL#g" \
#			-e "s#@PTXDIST_QMAKE_LIBS_OPENGL_ES2@#$(GLES2_LIBS)#g" \
#			-e "s#@PTXDIST_QMAKE_LIBS_OPENVG@##g" \
#		    $$file > $${file%%.in}; \
#	done
	@$(call touch)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

# don't use CROSS_ENV. Qt uses mkspecs for instead.
QT5_ENV		:= $(CROSS_ENV_PKG_CONFIG) INSTALL_ROOT=$(QT5_PKGDIR)
QT5_INSTALL_OPT	:= install INSTALL_ROOT=$(QT5_PKGDIR)

#
# autoconf
#
QT5_AUTOCONF := \
	-prefix /usr \
	-hostprefix $(PTXDIST_SYSROOT_CROSS) \
	-device linux-rasp-pi-g++ \
	-xplatform devices/linux-rasp-pi-g++ \
	-device-option CROSS_COMPILE=$(COMPILER_PREFIX) \
	-opensource \
	-confirm-license \
	-release \
	-no-rpath \
	-no-sql-ibase \
	-no-sql-mysql \
	-no-sql-odbc \
	-no-sql-psql \
	-no-sql-sqlite2 \
	-no-sql-sqlite1 \
	-no-sse \
	-no-sse2 \
	-no-sse3 \
	-no-ssse3 \
	-no-sse4.1 \
	-no-sse4.2 \
	-no-avx \
	-no-linuxfb \
	-no-optimized-qmake \
	-no-nis \
	-no-cups \
	-no-pch \
	-opengl es2 \
	-eglfs \
	-reduce-relocations \
	-reduce-exports \
	-force-pkg-config \
	-no-gtkstyle \
	-no-openvg \
	-shared \
	-make libs \
	-nomake tools \
	-nomake tests \
	-nomake examples \
	-c++11

#$(STATEDIR)/qt5.compile:
#	@$(call targetinfo)
#	@$(call touch)

QT5_INSTALL_OPT += install_subtargets

$(STATEDIR)/qt5.install:
	@$(call targetinfo)
	@$(call install, QT5)
	@find "$(QT5_PKGDIR)" -name "*.pri" -print0 | xargs -r -0 -- \
		sed -i -e "s#$(PTXDIST_SYSROOT_TARGET)#\$$\$$(SYSROOT)#g"
	@find "$(QT5_PKGDIR)" -name "*.la" -print0 | xargs -r -0 -- \
		sed -i -e "/^dependency_libs/s:\( \|-L\|-R\)$(QT5_PKGDIR)\(/lib\|/usr/lib\):\1$(SYSROOT)\2:g"
	@find "$(QT5_PKGDIR)" -name "*.prl" -print0 | xargs -r -0 -- \
		sed -i -e "/^QMAKE_PRL_LIBS/s:\( \|-L\|-R\)$(QT5_PKGDIR)\(/lib\|/usr/lib\):\1$(SYSROOT)\2:g"
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/qt5.install.post:
	@$(call targetinfo)
	@$(call world/install.post, QT5)
#       create a cross qmake:
#       copy host qmake and add a qt.conf (these must be in the same dir)
#       add wrapper script that sets the correct QMAKESPEC
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/lrelease
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/moc
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/qdbuscpp2xml
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/qdbusxml2cpp
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/qdoc
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/qmake
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/rcc
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/syncqt
	@rm -f $(PTXDIST_SYSROOT_CROSS)/bin/uic
	@rm -rf $(PTXDIST_SYSROOT_CROSS)/mkspecs/
	@mkdir -p $(PTXDIST_SYSROOT_CROSS)/bin/
	@cp $(QT5_PKGDIR)/$(PTXDIST_SYSROOT_CROSS)/bin/* $(PTXDIST_SYSROOT_CROSS)/bin/
	@cp -a $(QT5_PKGDIR)/$(PTXDIST_SYSROOT_CROSS)/mkspecs/ $(PTXDIST_SYSROOT_CROSS)/mkspecs/
	@echo "[Paths]" > $(PTXDIST_SYSROOT_CROSS)/bin/qt.conf
	@echo "Prefix=$(PTXDIST_SYSROOT_CROSS)" >> $(PTXDIST_SYSROOT_CROSS)/bin/qt.conf
	@echo "Binaries=$(PTXDIST_SYSROOT_CROSS)/bin/" >> $(PTXDIST_SYSROOT_CROSS)/bin/qt.conf
	@echo "Headers=$(SYSROOT)/usr/include/" >> $(PTXDIST_SYSROOT_CROSS)/bin/qt.conf
	@echo "Libraries=$(SYSROOT)/usr/lib/" >> $(PTXDIST_SYSROOT_CROSS)/bin/qt.conf
	@$(call touch)

$(STATEDIR)/qt5.targetinstall:
	@$(call targetinfo)

	@$(call install_init, qt5)
	@$(call install_fixup, qt5,PRIORITY,optional)
	@$(call install_fixup, qt5,SECTION,base)
	@$(call install_fixup, qt5,AUTHOR, "Michael Olbrich <m.olbrich@pengutronix.de>")
	@$(call install_fixup, qt5,DESCRIPTION,missing)

	@$(call install_lib, qt5, 0, 0, 0644,libQt5Bluetooth)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Concurrent)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Core)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5DBus)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Gui)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5MultimediaQuick_p)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Multimedia)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5MultimediaWidgets)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Network)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Nfc)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5OpenGL)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Positioning)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5PrintSupport)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Qml)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5QuickParticles)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Quick)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5QuickTest)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Script)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5ScriptTools)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Sensors)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5SerialPort)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Sql)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Svg)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Test)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Widgets)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5XmlPatterns)
	@$(call install_lib, qt5, 0, 0, 0644,libQt5Xml)

	@$(call install_tree, qt5, 0, 0, -, /usr/plugins/)
	@$(call install_tree, qt5, 0, 0, -, /usr/qml/)

	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/qml)
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/qmlbundle)
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/qmlscene)
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/qmltestrunner)
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/v4)
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/xmlpatterns)
	@$(call install_copy, qt5, 0, 0, 0755, -, /usr/bin/xmlpatternsvalidator)

	@$(call install_finish, qt5)

	@$(call touch)

# vim: syntax=make
