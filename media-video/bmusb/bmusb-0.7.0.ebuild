# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3

DESCRIPTION="USB Driver for Blackmagic Ultrastudio cards"
HOMEPAGE="https://git.sesse.net/?p=bmusb;a=summary"
EGIT_REPO_URI="https://git.sesse.net/bmusb"
EGIT_COMMIT="${PV}"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/libusb-1.0.20"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_install() {
	emake PREFIX="${D}usr" install
}
