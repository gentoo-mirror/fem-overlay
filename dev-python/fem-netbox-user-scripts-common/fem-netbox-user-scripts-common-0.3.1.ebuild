# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Common script modules for FeM e.V.'s NetBox"
HOMEPAGE="https://gitlab.fem-net.de/nexbox/netbox-user-scripts"
SRC_URI="https://gitlab.fem-net.de/nexbox/netbox-user-scripts/-/archive/v${PV}/netbox-user-scripts-v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/pynetbox-6.1.2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/netbox-user-scripts-v${PV}"

DOCS=("README.md" "CHANGELOG.md")
