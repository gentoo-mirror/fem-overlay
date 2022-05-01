# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Command-line XML beautifier and content extractor"
HOMEPAGE="https://github.com/sibprogrammer/xq"
SRC_URI="
	https://github.com/sibprogrammer/xq/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://gitlab.fem-net.de/api/v4/projects/309/packages/generic/${PN}/${PV}/${P}-deps.tar.xz
"

LICENSE="BSD MIT Apache-2.0 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	ego build -work -x
}

src_install() {
	default
	dobin xq
}
