# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="BlackMagic DeckLink Input-Debugger"
HOMEPAGE="https://github.com/voc/decklink-debugger"
EGIT_REPO_URI="https://github.com/voc/decklink-debugger"
EGIT_COMMIT="68fe227d79f4303aa09342dff7598675be19577c"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-video/decklink-drivers
		net-libs/libmicrohttpd
		media-libs/libpng:0"
RDEPEND="${DEPEND}"

src_configure() {
	cmake "${S}"
}

src_compile() {
	export CPLUS_INCLUDE_PATH="/opt/blackmagic-desktop-video/usr/include/blackmagic"
	default
}

src_install() {
	dobin decklink-debugger
	default
}
