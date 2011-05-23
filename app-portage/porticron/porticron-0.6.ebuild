# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/porticron/porticron-0.6.ebuild,v 1.3 2011/05/19 03:22:24 jer Exp $

EAPI="3"

inherit eutils

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="porticron"
GITHUB_COMMIT="eaf2457"

DESCRIPTION="porticron is a cron script to sync portage and send update mails to root"
HOMEPAGE="http://github.com/hollow/porticron"
SRC_URI="http://nodeload.github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${GITHUB_AUTHOR}-${GITHUB_PROJECT}-${GITHUB_COMMIT}

src_prepare() {
	epatch ${FILESDIR}/remove-dig.patch
}

src_install() {
	dosbin bin/porticron
	insinto /etc
	doins etc/porticron.conf
}
