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
PACKAGES-$(PTXCONF_OPENCV) += opencv

#
# Paths and names
#
ifdef PTXCONF_OPENCV_TRUNK
OPENCV_VERSION	:= trunk
else
OPENCV_VERSION	:= 2.4.7
OPENCV_MD5	:= 33a12a8bba6e6dc32c97298c99b083b2
endif
OPENCV		:= opencv-$(OPENCV_VERSION)
OPENCV_SUFFIX	:= tar.gz
OPENCV_URL	:= http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/$(OPENCV_VERSION)/$(OPENCV).$(OPENCV_SUFFIX)/download
OPENCV_SOURCE	:= $(SRCDIR)/$(OPENCV).$(OPENCV_SUFFIX)
OPENCV_DIR	:= $(BUILDDIR)/$(OPENCV)
OPENCV_LICENSE	:= BSD

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

#$(OPENCV_SOURCE):
#	@$(call targetinfo)
#	@$(call get, OPENCV)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#OPENCV_CONF_ENV	:= $(CROSS_ENV)

#
# cmake
#
OPENCV_CONF_TOOL	:= cmake
OPENCV_CONF_OPT	:= \
	$(CROSS_CMAKE_USR) \
	-DCMAKE_BUILD_TYPE=Release   \
	-DBUILD_SHARED_LIBS=ON    \
	-DBUILD_WITH_STATIC_CRT=OFF                                  \
	-DBUILD_DOCS=OFF          \
	-DBUILD_EXAMPLES=OFF                                         \
	-DBUILD_PACKAGE=OFF                                          \
	-DBUILD_TESTS=OFF \
	-DBUILD_PERF_TESTS=OFF \
	-DBUILD_WITH_DEBUG_INFO=OFF             \
	-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=OFF \
	-DCMAKE_SKIP_RPATH=OFF                  \
	-DCMAKE_USE_RELATIVE_PATHS=OFF          \
	-DENABLE_FAST_MATH=ON                   \
	-DENABLE_NOISY_WARNINGS=OFF             \
	-DENABLE_OMIT_FRAME_POINTER=ON          \
	-DENABLE_PRECOMPILED_HEADERS=OFF        \
	-DENABLE_PROFILING=OFF                  \
	-DENABLE_SOLUTION_FOLDERS=OFF           \
	-DOPENCV_CAN_BREAK_BINARY_COMPATIBILITY=ON \
	-DWITH_GSTREAMER=ON

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

libs= \
libopencv_calib3d \
libopencv_contrib \
libopencv_core \
libopencv_features2d \
libopencv_flann \
libopencv_gpu \
libopencv_highgui \
libopencv_imgproc \
libopencv_legacy \
libopencv_ml \
libopencv_nonfree \
libopencv_objdetect \
libopencv_ocl \
libopencv_photo \
libopencv_stitching \
libopencv_superres \
libopencv_video \
libopencv_videostab

$(STATEDIR)/opencv.targetinstall:
	@$(call targetinfo)

	@$(call install_init, opencv)
	@$(call install_fixup, opencv, PRIORITY, optional)
	@$(call install_fixup, opencv, SECTION, base)
	@$(call install_fixup, opencv, AUTHOR, "Tim Sander <tim@krieglstein.org>")
	@$(call install_fixup, opencv, DESCRIPTION, missing)
	@for i in $(shell cd $(OPENCV_PKGDIR) && find bin sbin usr/bin usr/sbin -type f); do \
		$(call install_copy, opencv, 0, 0, 0755, -, /$$i); \
	done; 
	@for i in $(libs); do \
		$(call install_lib, opencv, 0, 0, 0644, $$i); \
	done;
	#@for i in $(shell cd $(OPENCV_PKGDIR) && find usr/lib -type f); do \
	#	$(call install_lib, opencv, 0, 0, 0644, $(basename($$i))); \
	#done;
	@$(call install_finish, opencv)
	@$(call touch)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

#$(STATEDIR)/opencv.clean:
#	@$(call targetinfo)
#	@$(call clean_pkg, OPENCV)

# vim: syntax=make
