TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Flexible, easy-to-use configuration management system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.16.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfconf/${TERMUX_PKG_VERSION:0:4}/xfconf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=652a119007c67d9ba6c0bc7a740c923d33f32d03dc76dfc7ba682584e72a5425
TERMUX_PKG_DEPENDS="dbus, libxfce4util"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=no
"

termux_step_pre_configure() {
	termux_setup_gir
}
