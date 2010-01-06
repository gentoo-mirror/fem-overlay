# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ssvnc/ssvnc-1.0.24.ebuild,v 1.2 2010/01/05 16:24:59 vapier Exp $

EAPI="2"
inherit eutils multilib toolchain-funcs

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
	java? ( virtual/jdk )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.24-build.patch
	epatch "${FILESDIR}"/${PN}-1.0.24-optional-java.patch

	sed -i \
		-e '/CXXDEBUGFLAGS =/s:-O2:$(CXXFLAGS):' \
		-e '/CDEBUGFLAGS =/s:-O2:$(CFLAGS):' \
		vnc_unixsrc/vncviewer/Makefile
	sed -i \
		-e "/^LIB/s:lib/:$(get_libdir)/:" \
		-e "$(use java || echo '/^JSRC/s:=.*:=:')" \
		Makefile
	sed -i \
		-e '/^CC/s:=.*:+= $(CFLAGS) $(CPPFLAGS) $(LDFLAGS):' \
		vncstorepw/Makefile
}

src_compile() {
	emake || die
	emake all || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
