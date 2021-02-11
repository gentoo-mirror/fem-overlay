# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
inherit git-r3 distutils-r1

DESCRIPTION="Library to interact with the ArubaOS REST API"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/users/v0tti/repos/arubaos-client/browse"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/~v0tti/${PN}.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/netaddr-0.8.0
	>=dev-python/pytimeparse-1.1.8
	>=dev-python/requests-2.24.0
"
RDEPEND="${DEPEND}"
BDEPEND=""
