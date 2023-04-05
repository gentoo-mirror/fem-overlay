# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scripts to aid installing Linux system, originally for Arch Linux"
HOMEPAGE="https://archlinux.org/ https://github.com/archlinux/arch-install-scripts"
SRC_URI="https://github.com/archlinux/arch-install-scripts/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	!sys-apps/arch-chroot
"
BDEPEND="
	app-text/asciidoc
"

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}
