# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_FEM_DEP_ARCHIVE_VER="2025-10-31"
# Matches the version in internal/servers/hls/hlsjsdownloader/VERSION
HLSJS_PV="1.6.13"
inherit go-module-fem systemd

DESCRIPTION="Multi-protocol media server and streaming proxy for video and audio streams"
HOMEPAGE="https://github.com/bluenviron/mediamtx"
SRC_URI="
	https://github.com/bluenviron/mediamtx/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://cdn.jsdelivr.net/npm/hls.js@v${HLSJS_PV}/dist/hls.min.js -> hls-${HLSJS_PV}.min.js
	${GO_FEM_SRC_URI}
"

LICENSE="Apache-2.0 BSD ISC MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-user/mediamtx
	acct-group/mediamtx
"
BDEPEND="
	>=dev-lang/go-1.15
"

# Tests require access to Docker
RESTRICT="test"

src_prepare() {
	default

	# Manually add hls.min.js, as go generate would need Internet access to download files;
	cp -v "${DISTDIR}/hls-${HLSJS_PV}.min.js" "${S}/internal/servers/hls/hls.min.js" || die
	echo "v${PV}-gentoo-${PR}" > "internal/core/VERSION" || die

	# Default to file-based logging for OpenRC compatibility
	sed -i \
		-e 's#^logDestinations:.*#logDestinations: [file]#g' \
		-e 's#^logFile:.*#logFile: "/var/log/mediamtx/mediamtx.log"#g' \
		mediamtx.yml \
		|| die
}

src_install() {
	einstalldocs

	dobin "${PN}"

	insinto "/etc/mediamtx"
	doins mediamtx.yml

	newinitd "${FILESDIR}/${PN}-initd-r1" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd-r1" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	insinto "/etc/logrotate.d/"
	newins "${FILESDIR}/logrotate.conf" "${PN}.conf"
}
