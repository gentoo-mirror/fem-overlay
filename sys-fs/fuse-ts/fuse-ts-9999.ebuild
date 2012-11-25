# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit subversion eutils

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/fuse-ts"
ESVN_PROJECT="fuse-ts"

DESCRIPTION="FUSE module for working with splitted MPEG TS files"
HOMEPAGE="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="sys-fs/fuse
	>=dev-libs/mini-xml-2.6"
RDEPEND="${DEPEND}"

src_install() {
	dobin fuse-ts || die
}
