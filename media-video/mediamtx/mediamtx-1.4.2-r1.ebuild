# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_FEM_DEP_ARCHIVE_VER="2024-01-07"
inherit go-module-fem systemd

DESCRIPTION="Multi-protocol media server and streaming proxy for video and audio streams"
HOMEPAGE="https://github.com/bluenviron/mediamtx"
SRC_URI="
	https://github.com/bluenviron/mediamtx/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	${GO_FEM_SRC_URI}
"

LICENSE="Apache-2.0 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-user/mediamtx
	acct-group/mediamtx
"

src_prepare() {
	default

	# Default to file-based logging for OpenRC compatibility
	sed -i \
		-e 's#^logDestinations:.*#logDestinations: [file]#g' \
		-e 's#^logFile:.*#logFile: "/var/log/mediamtx/mediamtx.log"#g' \
		mediamtx.yml \
		|| die
}

src_compile() {
	ego build -work -ldflags="-X github.com/bluenviron/mediamtx/internal/core.version=v${PV}-gentoo-${PR}"
}

src_install() {
	einstalldocs

	dobin "${PN}"

	insinto "/etc/mediamtx"
	doins mediamtx.yml

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
