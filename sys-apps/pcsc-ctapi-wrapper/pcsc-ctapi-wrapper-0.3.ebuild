# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="A wrapper library for using smartcard readers that support PCSC only (e.g. SCR24x) with any application that supports CTAPI."
HOMEPAGE="http://pcsc-ctapi-wrapper.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcsc-ctapi-wrapper/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
