# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="JSON-Client for Almighty Lightweight Fact Remote Exchange Daemon"
HOMEPAGE="https://github.com/tcatm/alfred-json"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/tcatm/${PN}"
	KEYWORDS=""
else
	SRC_URI="https://github.com/tcatm/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-libs/jansson"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	dodoc README
}
