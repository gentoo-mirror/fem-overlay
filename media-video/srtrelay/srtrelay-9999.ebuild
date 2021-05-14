# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="SRT relay server to distribute media streams to multiple clients"
HOMEPAGE="https://github.com/voc/srtrelay"
SRC_URI=""
EGIT_REPO_URI="https://github.com/voc/srtrelay.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	net-libs/srt
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	git-r3_src_unpack

	cd "${S}"
	env GOCACHE="${T}/go-cache" \
		go mod download || die
}

src_compile() {
	env GOCACHE="${T}/go-cache" \
		go build -o ${PN} || die
}

src_install() {
	dobin ${PN}

	dodoc README.md

	insinto /etc/${PN}
	newins config.toml.example config.toml
}
