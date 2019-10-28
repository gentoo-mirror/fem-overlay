# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils meson

DESCRIPTION="A modern free software video mixer"
HOMEPAGE="https://nageru.sesse.net/"
SRC_URI="https://nageru.sesse.net/nageru-${PV}.tar.gz
	html? ( http://opensource.spotify.com/cefbuilds/cef_binary_77.1.18%2Bg8e8d602%2Bchromium-77.0.3865.120_linux64_minimal.tar.bz2 )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="html"

DEPEND="
virtual/opengl
>=media-video/movit-1.5.3
>=media-video/ffmpeg-4.0
media-sound/zita-resampler
>=media-video/bmusb-0.7.4
media-libs/libepoxy
dev-libs/protobuf
net-libs/libmicrohttpd
dev-qt/qtgui:5
dev-qt/qtopengl:5
dev-qt/qtprintsupport:5
dev-libs/qcustomplot
>=dev-lang/luajit-2.1.0_beta3
virtual/opengl
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}-pthread.patch"
	eapply "${FILESDIR}/${P}-cef.patch"
}

src_configure() {
	local cef_dir="${WORKDIR}/cef_binary_77.1.18+g8e8d602+chromium-77.0.3865.120_linux64_minimal"
	local emesonargs=(
		-Dcef_dir=$(usex html "${cef_dir}" "")
	)
	meson_src_configure
}
