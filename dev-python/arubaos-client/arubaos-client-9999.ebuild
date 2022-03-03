# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_8 python3_9 python3_10 )
inherit git-r3 distutils-r1

DESCRIPTION="Library to interact with the ArubaOS REST API"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/users/v0tti/repos/arubaos-client/browse"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.fem-net.de/technik/arubaos-client.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	>=dev-python/netaddr-0.8.0[${PYTHON_USEDEP}]
	>=dev-python/pytimeparse-1.1.8[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""
