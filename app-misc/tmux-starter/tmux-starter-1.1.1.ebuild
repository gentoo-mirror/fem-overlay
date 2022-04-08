# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Simple ncurses based interface for accessing tmux sessions"
HOMEPAGE="https://gitlab.com/NexAdn/tmux-starter"
SRC_URI="https://gitlab.com/NexAdn/tmux-starter/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sys-libs/ncurses
"
RDEPEND="
	${DEPEND}
	app-admin/sudo
	app-misc/tmux
"
BDEPEND=""

S="${WORKDIR}/${PN}-v${PV}"
