# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit git-2 eutils

DESCRIPTION="Basic capture and play programs for Blackmagic Design Decklink"
HOMEPAGE="https://github.com/lu-zero/bmdtools"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/ffmpeg
	media-video/decklink-drivers"

EGIT_REPO_URI="https://github.com/lu-zero/bmdtools.git"

S="${WORKDIR}/${PN}"

src_compile() {
	emake SDK_PATH=/usr/include/blackmagic
}

src_install() {
	einstall SDK_PATH=/usr/include/blackmagic
}
