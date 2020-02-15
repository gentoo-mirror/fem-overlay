# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools udev user git-r3

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
EGIT_REPO_URI="https://github.com/libimobiledevice/${PN}.git"

#SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=app-pda/libimobiledevice-1.2.1:=
	>=app-pda/libplist-1.11:=
	virtual/libusb:1
	virtual/udev"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --with-udevrulesdir="$(get_udevdir)"/rules.d
}

pkg_setup() {
	enewgroup plugdev
	enewuser usbmux -1 -1 -1 "usb,plugdev"
}
