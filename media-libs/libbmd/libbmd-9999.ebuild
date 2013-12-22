# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmad/libmad-0.15.1b-r7.ebuild,v 1.11 2013/04/25 19:18:11 radhermit Exp $

EAPI=4

inherit eutils autotools libtool flag-o-matic git-2

DESCRIPTION="C wrapper over Blackmagic Devices Decklink C++ api"
HOMEPAGE="https://github.com/lu-zero/libbmd"
SRC_URI=""

EGIT_REPO_URI="https://github.com/lu-zero/libbmd.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~ppc-aix ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="debug static-libs"

DEPEND="media-video/decklink-drivers"
RDEPEND="${DEPEND}"

DOCS="README.md"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--with-sdkdir="${EPREFIX}"/usr/include/blackmagic \
		--without-tools
}
