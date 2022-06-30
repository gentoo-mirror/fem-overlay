# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-bin}"
MATTERHORN_BUILD_ID=11383

DESCRIPTION="Terminal based Mattermost client"
HOMEPAGE="https://github.com/matterhorn-chat/matterhorn"
SRC_URI="https://gitlab.fem-net.de/nex/matterhorn-gentoo-bin/-/jobs/${MATTERHORN_BUILD_ID}/artifacts/raw/${P}.tar.bz2?inline=false -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	dev-libs/gmp:0/10.4
	sys-libs/ncurses:0/6
	sys-libs/zlib:0/1
"

QA_PREBUILT="*"

src_install() {
	default

	dobin matterhorn

	dodoc docs/commands.md
	dodoc docs/keybindings.md

	insinto /usr/share/${MY_PN}
	exeinto /usr/share/${MY_PN}/notification-scripts
	doins -r emoji
	doins -r syntax
	doexe notification-scripts/notify

	# syntax installs a separate LICENSE file
	find "${D}" -name "LICENSE" -delete || die
}
