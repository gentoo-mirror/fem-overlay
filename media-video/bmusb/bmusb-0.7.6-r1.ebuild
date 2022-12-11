# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 udev

DESCRIPTION="USB Driver for Blackmagic Ultrastudio cards"
HOMEPAGE="https://git.sesse.net/?p=bmusb;a=summary"
EGIT_REPO_URI="https://git.sesse.net/bmusb"
EGIT_COMMIT="${PV}"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=">=virtual/libusb-1-r2"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}/bmusb-0.7.6-respect-cflags-ldflags.patch"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		LIBDIR="/usr/$(get_libdir)" \
		UDEVDIR="$(get_udevdir)" \
		install

	use static-libs || find "${D}" -name "*.a" -delete
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
