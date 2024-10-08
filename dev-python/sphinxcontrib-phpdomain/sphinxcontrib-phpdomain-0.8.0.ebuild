# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Extension providing a Sphinx domain for describing PHP code"
HOMEPAGE="https://github.com/markstory/sphinxcontrib-phpdomain"
SRC_URI="
	https://github.com/markstory/sphinxcontrib-phpdomain/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
