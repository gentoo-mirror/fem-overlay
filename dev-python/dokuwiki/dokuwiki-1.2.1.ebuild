# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 pypi

DESCRIPTION="Library to manage DokuWiki via XML-RPC API"
HOMEPAGE="https://pypi.org/project/dokuwiki/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
