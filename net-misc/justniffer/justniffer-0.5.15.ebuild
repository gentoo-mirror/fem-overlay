# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="TCP packet sniffer supporting traffic logging in standard web server like format"
HOMEPAGE="https://onotelli.github.io/justniffer/"
SRC_URI="https://github.com/onotelli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost
	net-libs/libpcap"
RDEPEND="${DEPEND}"

src_prepare() {
	# disable python, since it's not converted to python 3
	sed -i -e 's;$(PYTHONSUBDIR);;' -e '/^ACLOCAL/d' "${S}/Makefile.am"
	rm -rf "${S}/m4" # remove old m4 files

	eautoreconf
	default_src_prepare
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc INSTALL README
}
