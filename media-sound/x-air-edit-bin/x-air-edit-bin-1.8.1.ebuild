# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

MY_PN="X-AIR-Edit"

DESCRIPTION="Graphical editor for the X32 mixer"
HOMEPAGE="https://www.behringer.com/"
SRC_URI="https://mediadl.musictribe.com/download/software/behringer/XAIR/${PV}/X-AIR-Edit_LINUX_${PV}.tar.gz"

LICENSE="x32edit-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
# Some required symbols are otherwise stripped out
RESTRICT="strip"

RDEPEND="
	media-libs/alsa-lib
	media-libs/freetype
	net-misc/curl
"
BDEPEND="
	dev-util/patchelf
"

S="${WORKDIR}"

DOCS=(
	"X-AIR-Edit_Release_History.txt"
)
QA_PREBUILT=( "usr/bin/${PN} ")

src_install() {
	einstalldocs
	newbin ${MY_PN} ${PN}

	make_desktop_entry /usr/bin/${PN} "${MY_PN//-/ }" ${PN} "AudioVideo;Audio"
}
