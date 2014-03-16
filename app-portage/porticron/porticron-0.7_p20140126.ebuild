# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/porticron/porticron-0.7_p20140126.ebuild,v 1.1 2014/02/06 08:30:46 xmw Exp $

EAPI="5"

inherit eutils vcs-snapshot

DESCRIPTION="cron script to sync portage and send update mails to root"
HOMEPAGE="http://github.com/hollow/porticron"
SRC_URI="https://github.com/hollow/${PN}/tarball/971dac3 -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE=""

RDEPEND="net-dns/bind-tools"
DEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/remove-dig-0.7.patch
}

src_install() {
	dosbin bin/porticron
	insinto /etc
	doins etc/porticron.conf
}
