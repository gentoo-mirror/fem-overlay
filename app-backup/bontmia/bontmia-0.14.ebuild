# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="An incremental network backup tool for snapshotting directories using rsync"
HOMEPAGE="http://folk.uio.no/johnen/bontmia/"
SRC_URI="http://folk.uio.no/johnen/bontmia/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="net-misc/rsync"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN}
	dodoc README
}
