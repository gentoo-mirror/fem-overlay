# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FFPLAYOUT_BUILD_ID=172267

inherit systemd

DESCRIPTION="Rust and ffmpeg based playout"
HOMEPAGE="https://github.com/ffplayout/ffplayout https://ffplayout.github.io/"
SRC_URI="https://gitlab.fem-net.de/gentoo/ffplayout-bin/-/jobs/${FFPLAYOUT_BUILD_ID}/artifacts/raw/${P}.tar.bz2"

S="${WORKDIR}/${P}"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0
	Unicode-DFS-2016 openssl
"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND="
	acct-user/ffplayout
	acct-group/ffplayout
"
RDEPEND="
	${DEPEND}
	media-video/ffmpeg
"

src_install() {
	default

	dobin ffplayout

	rm -r docs/images
	dodoc docs/*

	keepdir "/etc/ffplayout"
	fowners ffplayout:ffplayout /etc/ffplayout
	fperms 750 /etc/ffplayout

	keepdir "/var/log/ffplayout"
	fowners ffplayout:ffplayout /var/log/ffplayout

	systemd_dounit "${FILESDIR}/ffplayout.service"
}

pkg_postinst() {
	if [[ ! -f "/etc/ffplayout/ffplayout.toml" ]]; then
		elog "Please run"
		elog "    'ffplayout -i'"
		elog "as user 'ffplayout' once after installation"
		elog "to initialize the configuration and database."
	fi
}
