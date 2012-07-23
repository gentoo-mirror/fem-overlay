# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2

DESCRIPTION="iPXE network bootloader with many extra features such as DNS, HTTP and iSCSI"
HOMEPAGE="http://www.ipxe.org/"
EGIT_REPO_URI="git://git.ipxe.org/${PN}.git"

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

EGIT_SOURCEDIR="${S}"
S="${S}/src"

src_prepare(){
	# Fix mkisofs parameters
	sed -i \
		-e "/^mkisofs/s:-q:--quiet:" \
		util/genliso

	# delete build of iso from Makefile
	if ! use iso; then
		sed -i \
			-e "/^ALL/s:bin\/ipxe\.iso ::" \
			Makefile
	fi
}

src_install() {
	dodir /usr/share/ipxe/
	insinto /usr/share/ipxe/
	doins bin/ipxe.dsk
	doins bin/ipxe.usb
	use iso && doins bin/ipxe.iso
	doins bin/undionly.kpxe
	dodoc ../README
}
