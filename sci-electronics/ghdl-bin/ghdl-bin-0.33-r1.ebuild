# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="VHDL 2008/93/87 simulator"
HOMEPAGE="http://ghdl.free.fr/"
SRC_URI="https://github.com/tgingold/ghdl/releases/download/v${PV}/ghdl-${PV}-x86_64-linux.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

S=${WORKDIR}

QA_PREBUILT="*"

src_install() {
	dodir /usr
	cp -vR "${S}"/* "${ED}/usr" || die "Install failed!"
}
