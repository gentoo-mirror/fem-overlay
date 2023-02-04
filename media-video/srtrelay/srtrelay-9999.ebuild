# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_FEM_DEP_ARCHIVE_VER=
inherit go-module go-module-fem

DESCRIPTION="SRT relay server to distribute media streams to multiple clients"
HOMEPAGE="https://github.com/voc/srtrelay"
if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/voc/srtrelay.git"
else
	SRC_URI="
		https://github.com/voc/srtrelay/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
		${GO_FEM_SRC_URI}
	"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="
	>=net-libs/srt-1.4.2:=
"
RDEPEND="
	${DEPEND}

	acct-user/srtrelay
	acct-group/srtrelay
"

DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" = 9999* ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		default
	fi
}

src_install() {
	go-module-fem_src_install

	insinto /etc/${PN}
	newins config.toml.example config.toml

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate.conf" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
}
