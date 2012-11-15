# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib

MY_PN="Homer-Conferencing"
MY_BIN="Homer"

DESCRIPTION="Homer Conferencing (short: Homer) is a free SIP softphone with advanced audio and video support."
HOMEPAGE="http://www.homer-conferencing.com"

if [[ ${PV} == *9999* ]]; then
    inherit git-2
    EGIT_REPO_URI="git://github.com/${MY_PN}/${MY_PN}.git"
    KEYWORDS=""
else
    SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/V${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
    KEYWORDS="~x86 ~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/openssl-1.0
	media-libs/alsa-lib
	media-libs/libsdl[X,audio,video,alsa]
	media-libs/portaudio[alsa]
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/x264
	net-libs/sofia-sip
	virtual/ffmpeg[X]
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	x11-libs/qt-multimedia:4
	x11-libs/qt-webkit:4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	emake -C HomerBuild default \
		VERBOSE=1 \
		INSTALL_PREFIX=/usr/bin \
		INSTALL_LIBDIR=/usr/$(get_libdir) \
		INSTALL_DATADIR=/usr/share/${PN}
}

src_install() {
	emake -C HomerBuild install \
		VERBOSE=1 \
		DESTDIR="${D}"

	doicon ${MY_BIN}/${MY_BIN}.png
	make_desktop_entry "${PN}" "${MY_PN}" "${MY_PN}" "Telephony;VideoConference"
}
