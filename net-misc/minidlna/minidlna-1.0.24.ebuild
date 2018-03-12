# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="server software with the aim of being fully compliant with DLNA/UPnP-AV clients"
HOMEPAGE="http://minidlna.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-db/sqlite
	media-libs/flac
	media-libs/libexif
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libvorbis
	virtual/ffmpeg
	virtual/jpeg"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.18-Makefile.patch
}

src_configure() {
	./genconfig.sh || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	emake DESTDIR="${D}" install-conf

	newconfd "${FILESDIR}"/${PN}-1.0.23.confd ${PN}
	newinitd "${FILESDIR}"/${P}.initd ${PN}
}

pkg_postinst() {
	ewarn "minidlna no longer runs as root:root, per bug 394373."
	ewarn "Please edit /etc/conf.d/${PN} to suit your needs."
}
