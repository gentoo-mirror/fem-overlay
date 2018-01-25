# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=(python2_7)

inherit eutils python-r1

DESCRIPTION="TCP packet sniffer supporting traffic logging in standard web server like format"
HOMEPAGE="http://justsniffer.sourceforge.net"
SRC_URI="https://github.com/onotelli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's;python ;python2.7 ;' "${S}/python/Makefile.am"
	sed -i 's;python ;python2.7 ;' "${S}/python/Makefile.in"

	default_src_prepare
}

src_compile() {
	default_src_compile

	emake -C python || die "make python failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	emake DESTDIR="${D}" -C python install || die "make python install failed"
	dodoc INSTALL README
}
