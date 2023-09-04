# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Create MySQL- or PostgreSQL-Dumps via SSH using key-authentication."
HOMEPAGE="https://github.com/fem/sql-ssh-backup"
SRC_URI="https://github.com/fem/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"

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
