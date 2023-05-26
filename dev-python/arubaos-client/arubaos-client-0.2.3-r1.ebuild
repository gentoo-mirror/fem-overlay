# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Library to interact with the ArubaOS REST API"
HOMEPAGE="https://gitlab.fem-net.de/technik/arubaos-client"
SRC_URI="https://gitlab.fem-net.de/technik/arubaos-client/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/netaddr-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pytimeparse-1.1.8[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"
