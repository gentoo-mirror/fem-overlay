# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
#AUTOTOOLS_AUTORECONF=1
inherit autotools git-r3

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="http://www.libimobiledevice.org/"
#SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

EGIT_REPO_URI="https://github.com/libimobiledevice/libusbmuxd.git"
EGIT_COMMIT="07a493a570ddef69f5c424795345813fc9c32d6d"
#SRC_URI="https://codeload.github.com/libimobiledevice/libusbmuxd/zip/${EGIT_COMMIT}"

# tools/iproxy.c is GPL-2+, everything else is LGPL-2.1+
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0/2" # based on SONAME of libusbmuxd.so
KEYWORDS="~amd64"
IUSE="kernel_linux static-libs"

RDEPEND=">=app-pda/libplist-1.11:=
	virtual/libusb:1
	!~app-pda/usbmuxd-1.0.9
	!<app-pda/usbmuxd-1.0.8_p1"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig"

DOCS=( AUTHORS README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=( $(use_enable static-libs static) )
	use kernel_linux || myeconfargs+=( --without-inotify )

	econf "${myeconfargs[@]}" "${@}"

}
