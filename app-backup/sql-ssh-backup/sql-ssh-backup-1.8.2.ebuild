# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Create MySQL- or PostgreSQL-Dumps via SSH using key-authentication."
HOMEPAGE="https://github.com/fem/sql-ssh-backup"
SRC_URI="https://github.com/fem/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RESTRICT="test"

RDEPEND="net-misc/openssh"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN}
}

pkg_postinst() {
	elog "The command line option to select the database type has been altered."
	elog "Use sql-ssh-config -h for further information!"
}
