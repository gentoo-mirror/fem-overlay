# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 eutils

DESCRIPTION="Basic capture and play programs for Blackmagic Design Decklink"
HOMEPAGE="https://github.com/lu-zero/bmdtools"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/ffmpeg
	media-video/decklink-drivers"

EGIT_REPO_URI="https://github.com/lu-zero/bmdtools.git"

src_compile() {
	emake SDK_PATH=/usr/include/blackmagic
}

src_install() {
	emake SDK_PATH=/usr/include/blackmagic DESTDIR="${D}" install
}
