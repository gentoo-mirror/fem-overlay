# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

CORRUPTER_COMMIT="d7aecbb8b622a2c6fafe7baea5f718b46155be15"

DESCRIPTION="Simple image glitcher"
HOMEPAGE="https://github.com/r00tman/corrupter"
SRC_URI="https://github.com/r00tman/corrupter/archive/${CORRUPTER_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-${CORRUPTER_COMMIT}"

src_compile() {
	ego build -work -x -o corrupter
}

src_install() {
	default
	dobin corrupter
}
