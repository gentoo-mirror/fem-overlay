# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python git

DESCRIPTION="MLT Video Server (formerly Miracle)"
HOMEPAGE="http://mltframework.org/gitweb/melted.git"

EGIT_REPO_URI="git://mltframework.org/melted.git"
#EGIT_COMMIT="master"
#EGIT_BRANCH="${EGIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	git_submodules init
	git_submodules update
}

src_configure() {
	econf --enable-gpl || die "econf failed"
}

src_install() {
	emake DESTROOT="${D}" install || die "emake install failed"
}
