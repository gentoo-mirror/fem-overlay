# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit subversion eutils

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/bm-capture-multicard"
ESVN_PROJECT="${PN}"

DESCRIPTION="Capture tool for Blackmagic Decklink Cards with multicard support"
HOMEPAGE="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"
LICENSE="Blackmagic Design"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

EAPI="2"

DEPEND="media-libs/decklink-libs"
RDEPEND="media-video/decklink-drivers"

src_install() {
	dobin Capture || die
}
