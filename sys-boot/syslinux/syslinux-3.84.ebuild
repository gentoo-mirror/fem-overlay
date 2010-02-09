# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="SysLinux, IsoLinux and PXELinux bootloader"
HOMEPAGE="http://syslinux.zytor.com/"
SRC_URI="mirror://kernel/linux/utils/boot/syslinux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="sys-fs/mtools
		dev-perl/Crypt-PasswdMD5
		dev-perl/Digest-SHA1"
DEPEND="${RDEPEND}
	dev-lang/nasm"

# This ebuild is a departure from the old way of rebuilding everything in syslinux
# This departure is necessary since hpa doesn't support the rebuilding of anything other
# than the installers.

# removed all the unpack/patching stuff since we aren't rebuilding the core stuff anymore

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-3.72-nopie.patch
	# Don't prestrip, makes portage angry
	epatch "${FILESDIR}"/${PN}-3.72-nostrip.patch

	rm -f gethostip #bug 137081
}

src_compile() {
	emake installer || die
}

src_install() {
	emake INSTALLSUBDIRS=utils INSTALLROOT="${D}" MANDIR=/usr/share/man install || die
	dodoc README NEWS TODO doc/*
}
