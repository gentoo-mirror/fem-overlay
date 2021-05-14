# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit git-r3 distutils-r1

DESCRIPTION="Common script modules for FeM e.V.'s NetBox"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/projects/NETBOX/repos/netbox-user-scripts/browse"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/netbox/netbox-user-scripts.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/pynetbox-6.1.2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	distutils-r1_src_install
	dodoc README.md CHANGELOG.md
}
