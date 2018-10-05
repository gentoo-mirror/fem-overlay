# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools udev user git-r3

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
#SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

EGIT_REPO_URI="https://github.com/libimobiledevice/usbmuxd.git"
EGIT_COMMIT="f838cf6dc212c779562984e8a16a4cedfc1d6daf"
#SRC_URI="https://codeload.github.com/libimobiledevice/usbmuxd/zip/${EGIT_COMMIT}"
#SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="~app-pda/libimobiledevice-1.2.1_pre20181004
	>=app-pda/libplist-1.11
	virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig"

pkg_setup() {
	enewgroup plugdev
	enewuser usbmux -1 -1 -1 "usb,plugdev"
}

src_prepare() {
	default
	eautoreconf
}

src_install() {
	udevrulesdir="$(get_udevdir)"/rules.d
	econf "${myeconfargs[@]}" "${@}"
}
