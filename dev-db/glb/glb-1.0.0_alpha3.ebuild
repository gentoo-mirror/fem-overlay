# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools fixheadtails eutils multilib scons-utils toolchain-funcs

DESCRIPTION="Galera Load Balancer - a user-space TCP load balancer similar to Pen"
HOMEPAGE="http://www.codership.com"
SRC_URI="http://www.codership.com/files/glb/glb-1.0.0alpha3.tar.gz -> glb-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="splice"

RDEPEND=""
DEPEND="${RDEPEND}"
S="${WORKDIR}/${P/_/}"

src_prepare() {
	epatch "${FILESDIR}"/001_ISO_C90_decimal_constant_is_unsigned_only-1.0.0_alpha3.patch
}

src_configure() {
	econf $(use_enable splice )
}

src_install() {
	newconfd "${FILESDIR}/glbd.confd" glbd
	newinitd "${FILESDIR}/glbd.initd" glbd
	emake DESTDIR="${D}" install
}
