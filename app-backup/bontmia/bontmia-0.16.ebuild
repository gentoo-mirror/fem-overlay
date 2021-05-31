# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An incremental network backup tool for snapshotting directories using rsync"
HOMEPAGE="http://folk.uio.no/johnen/bontmia/"
SRC_URI="https://github.com/mape2k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-misc/rsync
	net-dns/bind-tools"
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN}
	newdoc README.md README
}
