# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python git

DESCRIPTION="an RTMP flash streaming server, written in erlang"
HOMEPAGE="http://erlyvideo.org/"

EGIT_REPO_URI="git://github.com/erlyvideo/erlyvideo.git"
#EGIT_COMMIT="master"
#EGIT_BRANCH="${EGIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/erlang-14.1
	dev-lang/ruby"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	git_submodules init
	git_submodules update
}

src_install() {
	emake DESTROOT="${D}" install || die "emake install failed"
}
