# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit libtool flag-o-matic eutils multilib autotools

DESCRIPTION="Send announces for the programs streamed by VLS with the mini-SAP-Server"
HOMEPAGE="http://www.videolan.org/"
SRC_URI="http://download.videolan.org/pub/videolan/miniSAPserver/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="slp"

RDEPEND="slp? ( net-libs/openslp )"

DEPEND="${RDEPEND}"


src_configure() {
	econf 	$(use_enable slp) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "econf failed"
}
