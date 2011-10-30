# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/iperf/iperf-2.0.5.ebuild,v 1.6 2010/10/10 18:48:12 armin76 Exp $

inherit eutils python

EAPI="4"

DESCRIPTION="tcp packet sniffer which can log network traffic in a 'standard' (web server like) or in a customized way"
HOMEPAGE="http://justsniffer.sourceforge.net/"
SRC_URI="${P/-/_}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE=""
RESTRICT="fetch"

DEPEND="dev-util/boost-build
	net-libs/libpcap"
RDEPEND="dev-util/boost-build
	net-libs/libpcap"

pkg_nofetch() {
	einfo "Portage is dumb! See bug #102607"

	einfo "Please download ${P/-/_}.tar.gz from:"
	einfo "http://sourceforge.net/project/platformdownload.php?group_id=205860&sel_platform=4737"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack "${A}"
	cd "${S}"
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
