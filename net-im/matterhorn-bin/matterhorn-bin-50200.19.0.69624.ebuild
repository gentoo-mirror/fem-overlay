# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"
MY_PV="$(ver_cut 1-3)"
MY_P="${PN}-${MY_PV}"
MATTERHORN_BUILD_ID="$(ver_cut 4)"

DESCRIPTION="Terminal based Mattermost client"
HOMEPAGE="https://github.com/matterhorn-chat/matterhorn"
SRC_URI="https://gitlab.fem-net.de/nex/matterhorn-gentoo-bin/-/jobs/${MATTERHORN_BUILD_ID}/artifacts/raw/${MY_P}.tar.bz2?inline=false -> ${P}.tar.bz2"

# BSD for software, Apache-2.0 for emojis
LICENSE="BSD Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	dev-libs/gmp:0/10.4
	sys-libs/ncurses:0/6
	sys-libs/zlib:0/1
"

QA_PREBUILT="*"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
	default

	dobin matterhorn

	dodoc docs/commands.md
	dodoc docs/keybindings.md
	newdoc emoji/NOTICE.txt emoji-notice.txt

	insinto /usr/share/${MY_PN}
	doins -r syntax

	insinto /usr/share/${MY_PN}/emoji
	doins emoji/*.json

	exeinto /usr/share/${MY_PN}/notification-scripts
	doexe notification-scripts/notify

	# syntax installs a separate LICENSE file
	find "${D}" -name "LICENSE" -delete || die
}
