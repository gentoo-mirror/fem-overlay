# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"
VALA_MIN_API_VERSION="0.30"

inherit cmake-utils git-r3 gnome2-utils vala

DESCRIPTION="A modern Jabber/XMPP Client using GTK+/Vala"
HOMEPAGE="https://github.com/dino/dino"
EGIT_REPO_URI="https://github.com/dino/dino.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="$(vala_depend)
	>=x11-libs/gtk+-3.22:3
	app-crypt/gpgme
	dev-db/sqlite
	dev-libs/libgcrypt:0=
	dev-libs/libgee:0.8
	net-libs/libsoup"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
