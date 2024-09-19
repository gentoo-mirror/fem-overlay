# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Collection of useful code fragments"
HOMEPAGE="
	https://pypi.org/project/kitchen/
"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

# uses nose for testing
RESTRICT="test"
