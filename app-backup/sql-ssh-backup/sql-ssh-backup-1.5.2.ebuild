# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Create MySQL- or PostgreSQL-Dumps via SSH using RSA or DSA Authentication (private key)."
HOMEPAGE="http://www.fem.tu-ilmenau.de/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RESTRICT="test"

RDEPEND="net-misc/openssh"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	newbin "${FILESDIR}"/${P} ${PN} || die "Installation failed."
}

pkg_postinst() {
	elog "The command line option to select the database type has been altered."
	elog "Use sql-ssh-config -h for further information!"
}
