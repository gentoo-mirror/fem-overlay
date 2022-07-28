# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Keeps track of every kernel module that has been modprobed."
HOMEPAGE="https://github.com/graysky2/modprobed-db https://wiki.archlinux.org/title/Modprobed-db"
SRC_URI="https://github.com/graysky2/modprobed-db/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	sys-apps/kmod
"

src_prepare() {
	default

	sed -i '/^.*gzip.*$/d' Makefile || die
}
