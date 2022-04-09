# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module git-r3

DESCRIPTION="SRT relay server to distribute media streams to multiple clients"
HOMEPAGE="https://github.com/voc/srtrelay"
SRC_URI=""
EGIT_REPO_URI="https://github.com/voc/srtrelay.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	>=net-libs/srt-1.4.2:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	ego build -v -o ${PN}
}

src_install() {
	dobin ${PN}

	dodoc README.md

	insinto /etc/${PN}
	newins config.toml.example config.toml
}
