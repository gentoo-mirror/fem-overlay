# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit git-2

DESCRIPTION="Cross-platform command line tools for working with MPEG data (TS, PS and ES)"
HOMEPAGE="http://code.google.com/p/tstools/"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""

EGIT_REPO_URI="https://code.google.com/p/tstools/"

S="${WORKDIR}/${PN}"

MAKEOPTS="${MAKEOPTS} -j1"

src_install()
{
	dobin bin/*
	dodoc docs/*	
}
