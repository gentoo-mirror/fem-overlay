# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils
DESCRIPTION="Thunderbolt(TM) user-space components"
HOMEPAGE="https://github.com/intel/thunderbolt-software-user-space"
SRC_URI="https://github.com/intel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
app-text/txt2tags
dev-libs/boost
"
RDEPEND="${DEPEND}"
