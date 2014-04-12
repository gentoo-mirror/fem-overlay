# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit readme.gentoo

DESCRIPTION="A shell frontend for duplicity"
HOMEPAGE="http://duply.net"
SRC_URI="mirror://sourceforge/ftplicity/${PN}_${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-backup/duplicity"

S=${WORKDIR}/${PN}_${PV}

DOC_CONTENTS="
If you use ${PN} at the first time please have a
look at the the usage help text \"${PN} --help\"
for further information."

src_install() {
	dobin ${PN}
	newdoc "${FILESDIR}/readme-${PV}.txt" readme.txt
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
