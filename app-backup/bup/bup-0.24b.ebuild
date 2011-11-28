# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Git for backups"
HOMEPAGE="https://github.com/apenwarr/bup"
SRC_URI="https://github.com/apenwarr/${PN}/tarball/${P} -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
# todo: test useflag to run make test
IUSE="doc"

DEPEND=">=dev-lang/python-2.4
        >=dev-vcs/git-1.5.3.1
        dev-python/fuse-python
        dev-python/pyxattr
        dev-python/pylibacl
        doc? ( app-text/pandoc )
"
RDEPEND="${DEPEND}"

DOCS="README CODINGSTYLE DESIGN"
S=${WORKDIR}/${PN}

src_unpack() {
        unpack "${A}"
        mv *-${PN}-* "${S}"
}


