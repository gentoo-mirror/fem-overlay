# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils autotools

DESCRIPTION="a production quality switch for VM environments that supports standard management interfaces (e.g. NetFlow, RSPAN, ERSPAN, IOS-like CLI), and is open to programmatic extension and control."
HOMEPAGE="http://www.openvswitch.org/"
SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl datapath"

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {
	linux-mod_pkg_setup

	local myconf=""
	use datapath && myconf="--with-l26="${KV_DIR}

	econf \
		$(use_enable ssl) \
		${myconf} \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

#	newinitd "${FILESDIR}/${PN}".init "${PN}"
	newinitd "${FILESDIR}/${PN}"-switch.init openvswitch-switch
	newconfd "${FILESDIR}/${PN}"-switch.conf openvswitch-switch

	dodir /etc/openvswitch
	keepdir /etc/openvswitch
	dodir /var/run/openvswitch
	keepdir /var/run/openvswitch
	dodir /var/log/openvswitch
	keepdir /var/log/openvswitch
#	fowners root:root /var/run/openvswitch
#	fperms 755 /var/run/openvswitch
}
