# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="pass integration for rofi"
HOMEPAGE="https://github.com/carnager/rofi-pass"
if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/carnager/rofi-pass.git"
else
	SRC_URI="https://github.com/carnager/rofi-pass/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	app-admin/pass
	app-admin/pwgen
	sys-apps/gawk
	x11-misc/rofi
	x11-misc/xclip
	x11-misc/xdotool
	x11-misc/xdg-utils
"

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
