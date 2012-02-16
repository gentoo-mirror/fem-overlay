# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils git-2

EAPI="4"
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


src_prepare(){
	cd "src"

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

src_compile() {
	cd "src"
	emake
}

src_install() {
	dodir /usr/share/ipxe/
	insinto /usr/share/ipxe/
	doins src/bin/ipxe.dsk
	doins src/bin/ipxe.usb
	use iso && doins src/bin/ipxe.iso
	doins src/bin/undionly.kpxe
	dodoc README
}
