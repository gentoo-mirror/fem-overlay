# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
inherit git-r3 python-single-r1

DESCRIPTION="FeM NRPE scripts for ArubaOS monitoring"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/scm/monitor/arubaos-nrpe-scripts.git"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/monitor/arubaos-nrpe-scripts.git"

if [[ ${PV} != *9999 ]]; then
	EGIT_COMMIT="v${PV}"
fi

LICENSE="MIT"
SLOT="0"

if [[ ${PV} != *9999 ]]; then
	KEYWORDS="~amd64"
fi

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/arubaos-client[${PYTHON_USEDEP}]')
"
DEPEND=""
BDEPEND=""

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	for plugin in *.py; do
		doexe ${plugin}
	done
}
