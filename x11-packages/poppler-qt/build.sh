TERMUX_PKG_HOMEPAGE=https://poppler.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Poppler Qt wrapper"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Please align the version with `poppler` package.
TERMUX_PKG_VERSION=22.04.0
TERMUX_PKG_REVISION=3
# Do not forget to bump revision of reverse dependencies and rebuild them
# when SOVERSION is changed.
_POPPLER_SOVERSION=120
TERMUX_PKG_SRCURL=https://poppler.freedesktop.org/poppler-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=813fb4b90e7bda63df53205c548602bae728887a60f4048aae4dbd9b1927deff
TERMUX_PKG_DEPENDS="poppler (>= ${TERMUX_PKG_VERSION}), qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
#texlive needs the xpdf headers
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DENABLE_GLIB=ON
-DENABLE_GOBJECT_INTROSPECTION=OFF
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON
-DENABLE_QT5=ON
-DENABLE_QT6=OFF
-DFONT_CONFIGURATION=fontconfig
"

termux_step_pre_configure() {
	# Certain packages are not safe to build on device because their
	# build.sh script deletes specific files in $TERMUX_PREFIX.
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	if ! test "${_POPPLER_SOVERSION}"; then
		termux_error_exit "Please set _POPPLER_SOVERSION variable."
	fi
	local sover_main=$(. $TERMUX_SCRIPTDIR/packages/poppler/build.sh; echo $_POPPLER_SOVERSION)
	if [ "${sover_main}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION mismatch with \"poppler\" package."
	fi
	local sover_cmake=$(sed -En 's/^.*set_target_properties\(poppler PROPERTIES .* SOVERSION ([0-9]+).*$/\1/p' CMakeLists.txt)
	if [ "${sover_cmake}" != "${_POPPLER_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed (CMakeLists.txt: \"${sover_cmake}\")."
	fi

	CPPFLAGS+=" -DCMS_NO_REGISTER_KEYWORD"
}

termux_step_post_massage() {
	find . ! -type d \
		! -wholename "./include/poppler/qt5/*" \
		! -wholename "./lib/libpoppler-qt5.so" \
		! -wholename "./lib/pkgconfig/poppler-qt5.pc" \
		! -wholename "./share/doc/$TERMUX_PKG_NAME/*" \
		-exec rm -f '{}' \;
	find . -type d -empty -delete
}
