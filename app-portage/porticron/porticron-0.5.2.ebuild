# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils

DESCRIPTION="porticron is a cron script to sync portage and send update mails to root"
HOMEPAGE="http://bb.xnull.de/projects/porticron/"
SRC_URI="http://bb.xnull.de/projects/porticron/dist/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch ${FILESDIR}/remove-dig.patch
}

src_install() {
	dosbin bin/porticron
	insinto /etc
	doins etc/porticron.conf
}
