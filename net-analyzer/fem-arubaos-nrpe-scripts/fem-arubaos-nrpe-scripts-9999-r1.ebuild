# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="FeM NRPE scripts for ArubaOS monitoring"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/scm/monitor/arubaos-nrpe-scripts.git"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/monitor/arubaos-nrpe-scripts.git"

if [[ ${PV} != *9999 ]]; then
	EGIT_COMMIT="v${PV}"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="
	dev-python/arubaos-client
"
BDEPEND=""

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	for plugin in *.py; do
		doexe ${plugin}
	done
}
