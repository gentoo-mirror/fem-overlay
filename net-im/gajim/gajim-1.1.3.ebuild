# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite,xml"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eapi7-ver gnome2-utils xdg-utils

DESCRIPTION="Jabber client written in PyGTK"
HOMEPAGE="https://www.gajim.org/"
SRC_URI="https://dev.gajim.org/gajim/gajim/-/archive/gajim-${PV}/gajim-gajim-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+crypt remote jingle keyring networkmanager upnp spell +webp rst omemo"

COMMON_DEPEND="
	dev-libs/gobject-introspection[cairo,${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
DEPEND="
	${COMMON_DEPEND}
	app-arch/unzip
	>=dev-util/intltool-0.40.1
	virtual/pkgconfig
	>=sys-devel/gettext-0.17-r1
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/pyasn1[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=dev-python/python-nbxmpp-0.6.9[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	>=dev-python/cssutils-1.0.2[${PYTHON_USEDEP}]
	dev-python/idna[${PYTHON_USEDEP}]
	dev-python/precis-i18n[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	crypt? ( dev-python/pycryptodome[${PYTHON_USEDEP}] )
	remote? (
		>=dev-python/dbus-python-1.2.0[${PYTHON_USEDEP}]
		dev-libs/dbus-glib
	)
	rst? ( dev-python/docutils[${PYTHON_USEDEP}] )
	keyring? ( dev-python/keyring[${PYTHON_USEDEP}] )
	jingle? (
		net-libs/farstream:0.2[introspection]
		media-libs/gstreamer:1.0[introspection]
		media-libs/gst-plugins-base:1.0[introspection]
		media-libs/gst-plugins-ugly:1.0
	)
	networkmanager? ( net-misc/networkmanager[introspection] )
	upnp? ( net-libs/gupnp-igd[introspection] )
	spell? (
		app-text/gspell[introspection]
		app-text/hunspell
	)
	omemo? (
		dev-python/python-axolotl[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
	)
	webp? ( dev-python/pillow[${PYTHON_USEDEP}] )
"

RESTRICT="test"

S="${WORKDIR}/gajim-${P}"

src_prepare() {
	default

	use spell || eapply "${FILESDIR}/disable-gspell-1.1.0.patch"
	use keyring || sed -i 's/keyring//' setup.cfg || die
}

python_install_all() {
	distutils-r1_python_install_all

	# Gajims build script compresses the man pages. Gentoo would like to
	# compress them itself.
	gunzip "${D}/usr/share/man/man1/gajim.1.gz"
	gunzip "${D}/usr/share/man/man1/gajim-history-manager.1.gz"
	use remote && gunzip "${D}/usr/share/man/man1/gajim-remote.1.gz"
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update

	ewarn "If you run into segfaults upon starting, you most likely ran into an issue"
	ewarn "with app-text/enchant (bug 662484). Use USE=\"-spell\" to remedy."
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
