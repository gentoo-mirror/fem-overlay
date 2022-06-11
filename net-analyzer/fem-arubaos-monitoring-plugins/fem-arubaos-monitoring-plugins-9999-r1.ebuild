# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
fi
inherit ${SCM:-} python-single-r1

DESCRIPTION="FeM NRPE scripts for ArubaOS monitoring"
HOMEPAGE="https://gitlab.fem-net.de/monitoring/arubaos-monitoring-plugins"
if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://gitlab.fem-net.de/monitoring/arubaos-monitoring-plugins.git"
else
	SRC_URI="https://gitlab.fem-net.de/monitoring/arubaos-monitoring-plugins/-/archive/v${PV}/arubaos-monitoring-plugins-v${PV}.tar.gz -> ${P}.tar.gz"
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

if [[ ${PV} != *9999 ]]; then
	S="${WORKDIR}"/arubaos-monitoring-plugins-v${PV}
fi

src_install() {
	python_scriptinto /usr/$(get_libdir)/nagios/plugins
	for plugin in *.py; do
		python_doscript ${plugin}
	done
}
