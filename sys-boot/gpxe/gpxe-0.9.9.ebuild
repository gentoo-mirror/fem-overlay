# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="gPXE network bootloader with many extra features such as DNS, HTTP and iSCSI"
HOMEPAGE="http://www.etherboot.org/"
SRC_URI="http://etherboot.org/rel/gpxe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="+iso"

RDEPEND="sys-fs/mtools
		dev-perl/Crypt-PasswdMD5
		dev-perl/Digest-SHA1
		sys-boot/syslinux"
DEPEND="${RDEPEND}
	dev-lang/nasm
	iso? ( virtual/cdrtools )"

S="${S}/src"

src_prepare() {

	# Fix path to isolinux.bin
	sed -i \
		-e "/^ISOLINUX_BIN/s:lib:share:" \
		arch/i386/Makefile

	# Fix mkisofs parameters
	sed -i \
		-e "/^mkisofs/s:-q:--quiet:" \
		util/genliso

	if ! use iso; then
		# delete build of iso from Makefile
		sed -i \
			-e "/^all/s:bin\/gpxe\.iso ::" \
			Makefile
	fi
}

src_install() {
	dodir /usr/share/gpxe/
	insinto /usr/share/gpxe/
	doins bin/gpxe.dsk
	doins bin/gpxe.usb
	use iso && doins bin/gpxe.iso
	doins bin/undionly.kpxe
	dodoc ../README ../LOG
}
