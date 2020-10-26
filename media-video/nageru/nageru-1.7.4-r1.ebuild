# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A modern free software video mixer"
HOMEPAGE="https://nageru.sesse.net/"
SRC_URI="https://nageru.sesse.net/nageru-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
virtual/opengl
>=media-video/movit-1.5.3
>=media-video/ffmpeg-3.1
media-libs/zita-resampler
media-video/bmusb
media-libs/libepoxy
dev-libs/protobuf
net-libs/libmicrohttpd
dev-qt/qtgui:5
dev-qt/qtopengl:5
dev-qt/qtprintsupport:5
dev-libs/qcustomplot
dev-lang/luajit
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/${P}-makefile.patch"
}
