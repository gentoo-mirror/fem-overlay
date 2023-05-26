# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Python library to interact with the NetBox REST API"
HOMEPAGE="https://pypi.org/project/pynetbox/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	<dev-python/requests-3[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

# Tests require pytest-docker, which is not present in ::gentoo or
# ::fem-overlay
RESTRICT="test"
