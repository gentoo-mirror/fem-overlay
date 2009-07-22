# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/radvd/radvd-1.2.ebuild,v 1.2 2009/04/25 23:13:17 patrick Exp $

inherit eutils autotools

DESCRIPTION="Network Discovery Daemon for LLDP, EDP, CDP, SONMP and FDP"
HOMEPAGE="https://trac.luffy.cx/lldpd"
SRC_URI="http://www.luffy.cx/lldpd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdp fdp edp sonmp lldpmed dot1 dot3 snmp"

RDEPEND="snmp? ( net-analyzer/net-snmp )"
DEPEND="${RDEPEND}"

src_compile() {
	econf \
		$(use_with snmp) \
		$(use_enable cdp) \
		$(use_enable fdp) \
		$(use_enable edp) \
		$(use_enable sonmp) \
		$(use_enable lldpmed) \
		$(use_enable dot1) \
		$(use_enable dot3) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	newinitd "${FILESDIR}/${PN}".init "${PN}"
	newconfd "${FILESDIR}/${PN}".conf "${PN}"

	# location of radvd.pid needs to be writeable by the radvd user
	keepdir /var/run/lldpd
	chown -R _lldpd:_lldpd "${D}"/var/run/lldpd
	fperms 755 /var/run/lldpd
}
