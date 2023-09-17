# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://github.com/a-tze/fuse-ts.git"

DESCRIPTION="FUSE module for working with splitted MPEG TS files"
HOMEPAGE="https://github.com/a-tze/fuse-ts"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="sys-fs/fuse:0
	>=dev-libs/mxml-2.6"
RDEPEND="${DEPEND}"

src_install() {
	dobin fuse-ts || die
}
