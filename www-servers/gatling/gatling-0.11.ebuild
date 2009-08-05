# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="high performance web server"
HOMEPAGE="http://www.fefe.de/gatling/"
SRC_URI="http://dl.fefe.de/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-libs/libowfat-0.27
	dev-libs/dietlibc"
RDEPEND=""

src_unpack() {
	unpack $A
	cd "${S}"

	epatch "${FILESDIR}/gentoo-vars.patch"
}

src_compile() {
	emake gatling || die "emake gatling failed"
}

src_install() {
	dobin gatling || die "installing binary failed"
	doman gatling.1 || die "installing manpage failed"
}
