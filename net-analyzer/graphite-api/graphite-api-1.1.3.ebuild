# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Graphite-web, without the interface. Just the rendering HTTP API."
HOMEPAGE="http://graphite-api.readthedocs.org"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
EGO_PN="github.com/${PN}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cache"

RDEPEND="
	cache? ( dev-python/flask-cache[${PYTHON_USEDEP}] )
	dev-python/cairocffi[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-1.5.7[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_install() {
	distutils-r1_python_install \
        --install-data="${EPREFIX}"/usr/share/${PN}

	insinto /etc/
	doins "${FILESDIR}"/${PN}.yaml

	keepdir /var/lib/${PN}
	touch "${D}/var/lib/${PN}/index"
}

pkg_postinst() {
	einfo "You will still need to deploy ${PN}. Please check"
	einfo "http://graphite-api.readthedocs.org/en/latest/deployment.html"
	einfo "for more info. Additionally give your wsgi-user write-access"
	einfo "to /var/lib/${PN}/index"
}
