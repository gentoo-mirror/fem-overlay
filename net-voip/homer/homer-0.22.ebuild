# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
[[ ${PV} == "9999" ]] && GIT_ECLASS="git-2"
inherit eutils flag-o-matic multilib ${GIT_ECLASS}
unset GIT_ECLASS

MY_PN="Homer"

DESCRIPTION="Homer is a free cross-platform SIP softphone, which also supports video conferencing"
HOMEPAGE="http://www.homer-conferencing.com"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/${MY_PN}-Conferencing/${MY_PN}-Conferencing.git"
else
	SRC_URI="http://www.homer-conferencing.com/releases/${PV}/${MY_PN}-Source.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl:0
	media-libs/alsa-lib
	media-libs/libsdl[X,audio,video,alsa]
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

if [[ ${PV} != "9999" ]]; then
	S=${WORKDIR}
fi

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
}

src_install() {
	emake -C HomerBuild \
		INSTALL_PREFIX=/usr \
		INSTALL_LIBDIR=/usr/$(get_libdir) \
		install DESTDIR="${D}"

	newicon ${MY_PN}/${MY_PN}.png ${MY_PN}.png
	make_desktop_entry "${PN}" "${MY_PN} Conferencing" ${MY_PN} "Telephony;VideoConference"
}
