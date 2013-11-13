# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

GITHUB_AUTHOR="hollow"
GITHUB_PROJECT="porticron"
GITHUB_COMMIT="df727fef2d"

DESCRIPTION="porticron is a cron script to sync portage and send update mails to root"
HOMEPAGE="http://github.com/hollow/porticron"
SRC_URI="http://github.com/${GITHUB_AUTHOR}/${GITHUB_PROJECT}/archive/v${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/remove-dig-${PV}.patch
}

src_install() {
	dosbin bin/porticron
	insinto /etc
	doins etc/porticron.conf
}
