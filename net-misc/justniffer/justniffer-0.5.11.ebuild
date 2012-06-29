# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils python

DESCRIPTION="tcp packet sniffer which can log network traffic in a 'standard' (web server like)"
HOMEPAGE="http://justsniffer.sourceforge.net/"
SRC_URI="${P/-/_}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE=""
RESTRICT="fetch"

DEPEND="dev-libs/boost
	net-libs/libpcap"
RDEPEND="dev-libs/boost
	net-libs/libpcap"

pkg_nofetch() {
	einfo "Portage is dumb! See bug #102607"

	einfo "Please download ${P/-/_}.tar.gz from:"
	einfo "http://sourceforge.net/project/platformdownload.php?group_id=205860&sel_platform=4737"
	einfo "and move it to ${DISTDIR}"
}

src_prepare() {
#	unpack ${A}
#	cd "${S}"
	epatch "${FILESDIR}/libnet_configure_fix.patch"
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc INSTALL README
}
