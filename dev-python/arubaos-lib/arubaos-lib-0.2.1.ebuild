# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="An object oriented library to interact with the ArubaOS REST API"
HOMEPAGE="https://gitlab.fem-net.de/aruba-wlan/arubaos-lib"
SRC_URI="https://gitlab.fem-net.de/aruba-wlan/arubaos-lib/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.0.6[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"