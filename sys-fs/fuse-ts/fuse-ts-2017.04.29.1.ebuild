# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://stash.fem.tu-ilmenau.de/scm/broadcast/fuse-ts.git"
EGIT_BRANCH="feature-more-options"
DESCRIPTION="FUSE module for working with splitted MPEG TS files patched"
HOMEPAGE="https://github.com/a-tze/fuse-ts"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="debug"

inherit git-r3

DEPEND="sys-fs/fuse:0
	>=dev-libs/mxml-2.6"
RDEPEND="${DEPEND}"

src_compile() {
	if use debug ; then
		emake debug || die 'Emake failed'
	else
		default_src_compile
	fi
}
src_install() {
	dobin fuse-ts || die
}
