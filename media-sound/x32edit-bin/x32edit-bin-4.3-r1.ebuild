# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

MY_PN="X32-Edit"

LIBCURL_SONAME_VER="4"

DESCRIPTION="Graphical editor for the X32 mixer"
HOMEPAGE="https://www.behringer.com/"
SRC_URI="https://mediadl.musictribe.com/download/software/behringer/X32/X32-Edit_LINUX_${PV}.tar.gz"

LICENSE="x32edit-EULA"
SLOT="0"
KEYWORDS="-* amd64"
# Some required symbols are otherwise stripped out
RESTRICT="strip"

RDEPEND="
	media-libs/alsa-lib
	net-misc/curl
"
BDEPEND="
	dev-util/patchelf
"

S="${WORKDIR}"

DOCS=(
	"X32-Edit-Releasenote-${PV}.pdf"
	"X32-Edit-Release_History.txt"
)
QA_PREBUILT=( "usr/bin/${PN} ")

src_compile() {
	patchelf \
		--replace-needed \
			"libcurl-gnutls.so.${LIBCURL_SONAME_VER}" \
			"libcurl.so.${LIBCURL_SONAME_VER}" \
		X32-Edit \
		|| die "Failed to patch binary"
}

src_install() {
	newbin ${MY_PN} ${PN}
	newicon -s 512 ${MY_PN}_icon.png ${PN}

	make_desktop_entry /usr/bin/${PN} "${MY_PN//-/ }" ${PN} "AudioVideo;Audio"
}
