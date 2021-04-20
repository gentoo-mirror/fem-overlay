# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
inherit distutils-r1

DESCRIPTION="Python library to interact with the NetBox REST API"
HOMEPAGE="https://pypi.org/project/pynetbox/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
	>=dev-python/six-1[${PYTHON_USEDEP}]
	<dev-python/six-2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""
