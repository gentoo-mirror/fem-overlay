# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils meson

CEF_PV="81.2.17+gb382c62+chromium-81.0.4044.113"

DESCRIPTION="A modern free software video mixer"
HOMEPAGE="https://nageru.sesse.net/"
SRC_URI="https://nageru.sesse.net/nageru-${PV}.tar.gz
	html? ( http://opensource.spotify.com/cefbuilds/cef_binary_${CEF_PV//+/%2B}_linux64_minimal.tar.bz2 )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="html"

DEPEND="
virtual/opengl
>=media-video/movit-1.5.3
>=media-video/ffmpeg-4.0
media-libs/zita-resampler
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

src_configure() {
	local cef_dir="${WORKDIR}/cef_binary_${CEF_PV}_linux64_minimal"
	local emesonargs=(
		-Dcef_dir=$(usex html "${cef_dir}" "")
	)
	meson_src_configure
}
