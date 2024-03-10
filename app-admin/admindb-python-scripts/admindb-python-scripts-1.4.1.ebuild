# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 wrapper

MY_P="${PN}-v${PV}"

DESCRIPTION="Python utility scripts for use with FeM's AdminDB2"
HOMEPAGE="https://fem.tu-ilmenau.de https://gitlab.fem-net.de/admindb/admindb-python-scripts"
SRC_URI="https://gitlab.fem-net.de/admindb/admindb-python-scripts/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND=""
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/dokuwiki[${PYTHON_USEDEP}]
		dev-python/netaddr[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]

		>=dev-python/admindb-dbhandler-1.0.0[${PYTHON_USEDEP}]
	')
"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	default
	distutils-r1_src_install

	python_setup

	cd "${S}"/${PN//-/_} || die
	for script in *.py; do
		if [[ "${script}" == "__init__.py" ]]; then
			continue
		fi
		local script_wrapper_name="${script%.py}"
		script_wrapper_name="${script_wrapper_name//_/-}"
		make_wrapper "${script_wrapper_name}" "${EPYTHON} -m ${PN//-/_}.${script%.py}"
	done
}
