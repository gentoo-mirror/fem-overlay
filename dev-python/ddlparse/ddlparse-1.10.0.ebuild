# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Python DDL parser"
HOMEPAGE="
	https://github.com/jackscodemonkey/sphinx-sql
	https://pypi.org/project/ddlparse/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
"

# Tests require dependencies which aren't available
RESTRICT="test"
