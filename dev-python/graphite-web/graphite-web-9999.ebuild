# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils git-2

EGIT_REPO_URI="https://github.com/graphite-project/graphite-web.git"

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="http://graphite.wikidot.com/"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+apache"

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/python[sqlite]
	dev-python/carbon
	dev-python/django
	dev-python/pycairo
	dev-python/twisted
	dev-python/whisper
	apache? ( www-apache/mod_python )
	dev-python/django-tagging"
