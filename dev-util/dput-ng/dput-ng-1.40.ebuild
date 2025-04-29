# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Debian package uploading tool"
HOMEPAGE="https://salsa.debian.org/debian/dput-ng"
SRC_URI="https://salsa.debian.org/debian/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/python-debian[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
"

# Requires nose
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-fix-xdg-import.patch"
)

src_install() {
	distutils-r1_src_install

	python_setup
	python_doscript bin/*

	insinto "/usr/share/${PN}"
	for d in hooks commands interfaces uploaders schemas codenames; do
		doins -r "skel/${d}"
	done

	insinto "/etc/dput.d/"
	for d in metas profiles; do
		doins -r "skel/${d}"
	done
}
