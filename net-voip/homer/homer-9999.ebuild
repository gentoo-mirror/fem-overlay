# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils flag-o-matic multilib git-2

MY_PN="Homer"

DESCRIPTION="A free cross-platform SIP softphone, which also supports video conferencing"
HOMEPAGE="http://www.homer-conferencing.com"
EGIT_REPO_URI="git://github.com/${MY_PN}-Conferencing/${MY_PN}-Conferencing.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/openssl:0
	media-libs/alsa-lib
	media-libs/libsdl[X,audio,video,alsa]
	media-libs/portaudio
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

src_prepare() {
	# Add GIT commit ID to Version
	sed -i \
		-e "/^\#define RELEASE_VERSION_STRING/s/\([0-9]\)\"/\1-git-${EGIT_VERSION}]\"/" \
		Homer/include/Configuration.h
}

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

	doicon ${MY_PN}/${MY_PN}.png
	make_desktop_entry "${PN}" "${MY_PN} Conferencing" ${MY_PN} "Telephony;VideoConference"
}
