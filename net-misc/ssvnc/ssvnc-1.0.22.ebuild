# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ssvnc/ssvnc-1.0.22.ebuild,v 1.3 2009/06/29 20:55:26 maekke Exp $

inherit eutils multilib

DESCRIPTION="VNC viewer that adds encryption security to VNC connections"
HOMEPAGE="http://www.karlrunge.com/x11vnc/ssvnc.html"
SRC_URI="mirror://sourceforge/ssvnc/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="java"

RDEPEND="sys-libs/zlib
	media-libs/jpeg
	dev-libs/openssl
	dev-lang/tk
	java? ( virtual/jre )
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXaw
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}
	java? ( virtual/jdk )
	x11-misc/imake"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-optional-java.patch
	sed -i \
		-e '/CXXDEBUGFLAGS =/s:-O2:$(CXXFLAGS):' \
		-e '/CDEBUGFLAGS =/s:-O2:$(CFLAGS):' \
		vnc_unixsrc/vncviewer/Makefile
	sed -i \
		-e "/^LIB/s:lib/:$(get_libdir)/:" \
		-e "$(use java || echo '/^JSRC/s:=.*:=:')" \
		Makefile
}

src_compile() {
	emake || die
	emake all || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
