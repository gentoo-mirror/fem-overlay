# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

EAPI="4"
DESCRIPTION="gPXE network bootloader with many extra features such as DNS, HTTP and iSCSI"
HOMEPAGE="http://www.etherboot.org/"
SRC_URI="http://ftp.uni-frankfurt.de/kernel/software/boot/gpxe/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=" ~amd64 ~x86"
IUSE="+iso localboot"

RDEPEND="sys-fs/mtools
		dev-perl/Crypt-PasswdMD5
		dev-perl/Digest-SHA1
		sys-boot/syslinux"
DEPEND="${RDEPEND}
	dev-lang/nasm
	iso? ( virtual/cdrtools )"

src_unpack() {
	unpack ${A}
	cd "${S}/src"

	# Fix path to isolinux.bin
	sed -i \
		-e "/^ISOLINUX_BIN/s:lib:share:" \
		arch/i386/Makefile

	# Fix mkisofs parameters
	sed -i \
		-e "/^mkisofs/s:-q:--quiet:" \
		util/genliso	
	sed -i \
		-e "/^mkisofs/s:-q:--quiet:" \
		util/geniso	

	if ! use iso; then
		# delete build of iso from Makefile
		sed -i \
			-e "/^all/s:bin\/gpxe\.iso ::" \
			Makefile
	fi

	# use localboot-patch
	use localboot && epatch ${FILESDIR}/${P}-localboot.patch
}

src_compile() {
	cd "src"
	emake || die "emake failed"
}

src_install() {
	dodir /usr/share/gpxe/
	insinto /usr/share/gpxe/
	doins src/bin/gpxe.dsk
	doins src/bin/gpxe.usb
	use iso && doins src/bin/gpxe.iso
	doins src/bin/undionly.kpxe
	dodoc README LOG
}
