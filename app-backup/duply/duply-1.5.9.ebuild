# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="duply (grown out of ftplicity) is a shell frontend for duplicity."
HOMEPAGE="http://duply.net"
SRC_URI="mirror://sourceforge/ftplicity/${PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-backup/duplicity"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}_${PV}

src_install() {
	dobin duply
	dodoc INSTALL.txt
}

pkg_postinst() {
	elog "If you use duply at the first time please have a"
	elog "look at the the usage help text \"duply --help\""
	elog "for further information."
}
