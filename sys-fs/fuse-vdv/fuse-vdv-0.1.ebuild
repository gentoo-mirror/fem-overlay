# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit subversion eutils

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/fuse-vdv"
ESVN_PROJECT="fuse-vdv"

DESCRIPTION="FUSE module for working with splitted dv files"
HOMEPAGE="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

EAPI="2"

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}"

src_prepare() {
    sed -i 's/build: hello /build: /' "${S}/Makefile"
}

src_install() {
    dobin fuse-vdv || die
}