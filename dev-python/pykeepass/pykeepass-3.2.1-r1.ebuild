# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_8,3_9} )
inherit distutils-r1 git-r3

DESCRIPTION="Low-level library to interact with keepass databases (supports the v.4 format) "
HOMEPAGE="https://github.com/pschmitt/pykeepass"
SRC_URI="https://github.com/pschmitt/pykeepass/archive/${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/iSchluff/pykeepass.git"
EGIT_COMMIT="a018aed91cf8c94ffc54cf55fde8628f65261849"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/construct[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_prepare_all() {
	rm -r tests
	distutils-r1_python_prepare_all
}
