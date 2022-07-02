# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils fcaps

DESCRIPTION="Network packet and traffic generator and analyzer"
HOMEPAGE="https://ostinato.org/ https://github.com/pstavirs/ostinato"
SRC_URI="https://github.com/pstavirs/ostinato/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/protobuf:=
	dev-qt/qtcore:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtscript:5=
	dev-qt/qtxml:5=
	dev-qt/qtsvg:5=
	dev-qt/qtgui:5=
	net-libs/libpcap:=
"
RDEPEND="${DEPEND}"

FILECAPS=(
	cap_net_raw,cap_net_admin usr/bin/drone
)

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" -config release
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
