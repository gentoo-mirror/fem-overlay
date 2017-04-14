# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Tiny XML Library"
HOMEPAGE="http://www.msweet.org/projects.php?Z3"
SRC_URI="http://www.msweet.org/files/project3/mxml-${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	exec_prefix=${D}
	#${EPREFIX}/configure
	default
}

src_install() {
	emake DSTROOT="${D}" install
	#mkdir ${D}/usr/lib
	#sh ${WORKDIR}/${P}/install-sh ${D}
	#default
	#bash 0</dev/tty 1>/dev/tty
}
