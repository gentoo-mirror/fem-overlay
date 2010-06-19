# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils autotools

DESCRIPTION="a production quality switch for VM environments that supports standard management interfaces (e.g. NetFlow, RSPAN, ERSPAN, IOS-like CLI), and is open to programmatic extension and control."
HOMEPAGE="http://www.openvswitch.org/"
SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {
	econf \
		$(use_enable ssl) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

#	newinitd "${FILESDIR}/${PN}".init "${PN}"
#	newconfd "${FILESDIR}/${PN}".conf "${PN}"

#	dodir /var/run/openvswitch
#	keepdir /var/run/openvswitch
#	fowners root:root /var/run/openvswitch
#	fperms 755 /var/run/openvswitch
}
