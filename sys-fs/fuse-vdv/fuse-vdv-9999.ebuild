# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

SCM="git-2"

inherit eutils ${SCM}

EGIT_REPO_URI="https://github.com/a-tze/fuse-vdv.git"

# S="${WORKDIR}/${PN}"

DESCRIPTION="FUSE module for working with splitted dv files"
HOMEPAGE="https://github.com/a-tze/fuse-vdv"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="wavdemux"

DEPEND="sys-fs/fuse
	>=dev-libs/mini-xml-2.6"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with wavdemux)
}

src_install() {
	dobin fuse-vdv || die
}
