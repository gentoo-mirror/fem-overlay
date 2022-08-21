# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="pass integration for rofi"
HOMEPAGE="https://github.com/carnager/rofi-pass"
SRC_URI="https://github.com/carnager/rofi-pass/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	app-admin/pass
	app-admin/pwgen
	sys-apps/gawk
	x11-misc/rofi
	x11-misc/xclip
	x11-misc/xdotool
	x11-misc/xdg-utils
"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-install-no-doc.patch"
)

src_compile() {
	:
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}"
	dodoc README.md config.example
}
