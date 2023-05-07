# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 wrapper

MY_PN="${PN#fem-}"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="Python utility scripts for FeM's Aruba WLAN system"
HOMEPAGE="https://fem.tu-ilmenau.de https://gitlab.fem-net.de/aruba-wlan/arubawlan-python-scripts"
SRC_URI="https://gitlab.fem-net.de/aruba-wlan/arubawlan-python-scripts/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/admindb-dbhandler[${PYTHON_USEDEP}]
		dev-python/arubaos-client[${PYTHON_USEDEP}]
		dev-python/dokuwiki[${PYTHON_USEDEP}]
		dev-python/netaddr[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	default
	distutils-r1_src_install

	python_setup

	pushd "${S}"/${MY_PN} || die
	for script in *.py; do
		if [[ "${script}" == "__init__.py" ]]; then
			continue
		fi
		local script_wrapper_name="${script%.py}"
		script_wrapper_name="${script_wrapper_name//_/-}"
		make_wrapper "${script_wrapper_name}" "${EPYTHON} $(python_get_sitedir)/${MY_PN}/${script}"
	done
	popd || die

	pushd "${S}"/man || die
	doman *
}
