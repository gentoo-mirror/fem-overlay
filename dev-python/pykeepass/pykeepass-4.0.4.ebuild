# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Python library to interact with keepass databases (supports KDBX3 and KDBX4)"
HOMEPAGE="https://github.com/libkeepass/pykeepass"
SRC_URI="https://github.com/libkeepass/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	test? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/construct[${PYTHON_USEDEP}]
		dev-python/argon2-cffi[${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/future[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/construct[${PYTHON_USEDEP}]
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	default
	sed -i -e 's:Cryptodome:Crypto:' pykeepass/kdbx_parsing/common.py || die
	sed -i -e 's:Cryptodome:Crypto:' pykeepass/kdbx_parsing/twofish.py || die
}

python_install() {
	distutils-r1_python_install
}
