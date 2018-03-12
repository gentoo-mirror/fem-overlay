# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils pam

DESCRIPTION="PAM RADIUS authentication module"
HOMEPAGE="http://www.freeradius.org/pam_radius_auth/"
SRC_URI="ftp://ftp.freeradius.org/pub/radius/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-realm.patch
}

src_install() {
	dopammod pam_radius_auth.so

	insopts -m600
	insinto /etc/raddb
	doins "${FILESDIR}"/server

	dodoc README Changelog USAGE
}

pkg_postinst() {
	elog "Before you can use this you'll have to add RADIUS servers to /etc/raddb/server."
	elog "The usage of pam_radius_auth module is explained in /usr/share/doc/${PF}/USAGE."
}
