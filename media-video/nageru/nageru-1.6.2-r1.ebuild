# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A modern free software video mixer"
HOMEPAGE="https://nageru.sesse.net/"
SRC_URI="https://nageru.sesse.net/nageru-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
virtual/opengl
>=media-video/movit-1.5.3
>=media-video/ffmpeg-3.1
media-sound/zita-resampler
media-video/bmusb
media-libs/libepoxy
dev-libs/protobuf
net-libs/libmicrohttpd
dev-qt/qtgui:5
dev-qt/qtopengl:5
dev-qt/qtprintsupport:5
dev-libs/qcustomplot
dev-lang/lua:5.2
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/${P}-makefile.patch"
}
