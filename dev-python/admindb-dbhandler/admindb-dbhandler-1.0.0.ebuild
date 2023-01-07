# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="${PN#admindb-}"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="Python wrapper for interactions with FeM's AdminDB"
HOMEPAGE="https://fem.tu-ilmenau.de/ https://gitlab.fem-net.de/admindb/dbhandler"
SRC_URI="https://gitlab.fem-net.de/admindb/dbhandler/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/psycopg:2[${PYTHON_USEDEP}]
	')
"
BDEPEND=""

S="${WORKDIR}/${MY_P}"
