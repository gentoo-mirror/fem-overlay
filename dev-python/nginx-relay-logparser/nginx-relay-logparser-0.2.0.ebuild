# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )
inherit distutils-r1 git-r3

DESCRIPTION="Daemon providing prometheus-compatible stream viewer statistics"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/projects/BROADCAST/repos/nginx-relay-logparser"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/broadcast/nginx-relay-logparser.git"
EGIT_COMMIT="prometheus-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/prometheus_client-0.6.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

python_install_all() {
	newinitd distribution/${PN}.initd ${PN}
	newconfd distribution/${PN}.confd ${PN}

	distutils-r1_python_install_all
}
