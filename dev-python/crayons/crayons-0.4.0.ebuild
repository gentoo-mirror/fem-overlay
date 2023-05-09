# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11} )
inherit distutils-r1

DESCRIPTION="Text UI colors for Python"
HOMEPAGE="
	https://pypi.org/project/crayons/
	https://github.com/MasterOdin/crayons
"
SRC_URI="https://github.com/MasterOdin/crayons/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
"

# The package doesn't really provide a unit testing framework, but instead rely
# on running the tests manually in a regular terminal which supports colors.
# It doesn't make sense to run these tests in the ebuild (and they fail with
# unittest).
RESTRICT="test"
