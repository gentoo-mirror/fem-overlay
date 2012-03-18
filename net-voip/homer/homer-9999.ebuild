# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
[[ ${PV} == "9999" ]] && GIT_ECLASS="git-2"
inherit eutils flag-o-matic ${GIT_ECLASS}
unset GIT_ECLASS

DESCRIPTION="Homer is a free cross-platform SIP softphone, which also supports video conferencing."
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://github.com/Homer-Conferencing/Homer-Conferencing.git"
#else
#	SRC_URI="http://www.homer-conferencing.com/download/${P}.tar.gz"
fi
HOMEPAGE="http://www.homer-conferencing.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/ffmpeg
	media-libs/x264
	media-libs/alsa-lib
	net-libs/sofia-sip
	>=dev-libs/openssl-1.0
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-sound
	x11-libs/qt-core
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Instead of filtering --as-needed, append --no-as-needed
	append-ldflags $(no-as-needed)

}

src_install() {
	cd HomerBuild

	emake \
		INSTALL_PREFIX=/usr \
		INSTALL_LIBDIR=/usr/$(get_libdir) \
		install DESTDIR="${D}"

	cd ..
	newicon Homer/Homer.png Homer.png
	make_desktop_entry "${PN}" "Homer Conferencing" Homer "Telephony;VideoConference"
}
