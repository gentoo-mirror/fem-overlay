# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-v${PV}"

DESCRIPTION="FeM SSH utilities and configs"
HOMEPAGE="https://example.com/"
SRC_URI="https://gitlab.fem-net.de/nex/${PN}/-/archive/v${PV}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	net-misc/sshpass
	virtual/ssh
"

S="${WORKDIR}/${MY_P}"

src_compile() {
	:
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
