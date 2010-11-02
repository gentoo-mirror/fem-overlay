# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python git perl-module

DESCRIPTION="This was designed to make rebroadcasting audio and video data over a network simple."
HOMEPAGE="http://github.com/revmischa/rtsp-server"

EGIT_REPO_URI="http://github.com/revmischa/rtsp-server.git"
#EGIT_COMMIT="master"
#EGIT_BRANCH="${EGIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/perl-5.12.2"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	git_submodules init
	git_submodules update
}
