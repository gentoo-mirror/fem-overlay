# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils

DESCRIPTION="duply (grown out of ftplicity) is a shell frontend for duplicity."
HOMEPAGE="http://checkbashisms.sf.net"
SRC_URI="mirror://sourceforge/project/checkbaskisms/${PV}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="perl-core/Getopt-Long"

DEPEND="${RDEPEND}"

src_unpack() {
	cp ${DISTDIR}/${PN} ${WORKDIR}/${PN}
}

src_install() {
	dobin ${WORKDIR}/${PN}
}
