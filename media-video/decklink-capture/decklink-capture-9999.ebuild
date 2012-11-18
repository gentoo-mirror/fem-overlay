# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit subversion eutils

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/bm-capture-multicard"
ESVN_PROJECT="${PN}"

DESCRIPTION="Capture tool for Blackmagic Decklink Cards with multicard support"
HOMEPAGE="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"
LICENSE="BlackMagicDesign"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="media-video/decklink-drivers"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's;SDK_PATH=../../include;SDK_PATH=/usr/include/blackmagic;' "${S}/Makefile"
}

src_install() {
	dobin Capture || die
}
