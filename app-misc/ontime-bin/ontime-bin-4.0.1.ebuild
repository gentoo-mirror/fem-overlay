# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop systemd xdg

DESCRIPTION="Digital flexible timetable for live events"
HOMEPAGE="https://www.getontime.no/"
SRC_URI="https://github.com/cpvalente/ontime/releases/download/v${PV}/ontime-linux.AppImage -> ${P}.AppImage"

S="${WORKDIR}/squashfs-root"

# Disclaimer: this list is almost certainly incomplete,
# but it's hard to find the licenses in all this bundled mess
LICENSE="BSD GPL-2+ GPL-3+ MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+headless"

# ontime pulls in a bunch of common desktop libs as runtime deps
RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	x11-libs/libxkbcommon
	x11-libs/gtk+:3=

	headless? (
		acct-user/ontime
		acct-group/ontime

		x11-misc/xvfb-run
	)
"
BDEPEND="
	sys-fs/squashfs-tools
"

PATCHES=(
	"${FILESDIR}/desktop-r1.patch"
)

QA_PREBUILT="opt/*"

# do a /opt install since the AppImage violates FHS standards quite a bit
MY_OPTDIR="/opt/${PN}"

src_unpack() {
	cp "${DISTDIR}/${P}.AppImage" ./ontime.AppImage || die
	chmod +x ontime.AppImage || die
	ebegin "Unpacking AppImage"
	./ontime.AppImage --appimage-extract
	eend $?
}

src_prepare() {
	default
	sed -i "/^#!/a APPDIR='${MY_OPTDIR}'" AppRun \
		|| die "Failed to patch AppRun script"
}

src_install() {
	# AppRun has been prepared to use MY_OPTDIR as fixed APPDIR
	newbin AppRun "${PN}"

	# auxiliary data and libs
	insinto "${MY_OPTDIR}"
	doins -r \
		locales \
		resources \
		./*.pak \
		./*.dat \
		./*.bin \
		./*.json

	exeinto "${MY_OPTDIR}/usr/lib"
	doexe ./usr/lib/lib*.so*

	# libs that need to reside in the same dir as exe for Google reasons
	exeinto "${MY_OPTDIR}"
	doexe \
		./*.so \
		./*.so.* \
		chrome-sandbox \
		chrome_crashpad_handler \
		ontime

	# contains only icon files, should be installed outside /opt
	insinto "/usr"
	doins -r "usr/share"

	newmenu ontime.desktop "${PN%-bin}.desktop"

	if use headless; then
		insinto "/etc/logrotate.d/"
		newins "${FILESDIR}/logrotate.conf" "${PN%-bin}.conf"
		newinitd "${FILESDIR}/ontime-initd" "${PN%-bin}"
		systemd_dounit "${FILESDIR}/ontime.service"
	fi
}
