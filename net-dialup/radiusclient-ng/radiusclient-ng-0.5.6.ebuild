# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils

DESCRIPTION="RadiusClient NextGeneration - library for RADIUS clients accompanied with several client utilities"
HOMEPAGE="http://developer.berlios.de/projects/radiusclient-ng/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="-add_tunnel"

DEPEND="!net-dialup/radiusclient
	!net-dialup/freeradius-client"
RDEPEND="${DEPEND}"


src_prepare() {
	if use add_tunnel; then
        	epatch "${FILESDIR}/${PN}-0.5.6.add-tunnel.diff"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README BUGS CHANGES COPYRIGHT
	dohtml doc/instop.html
}
