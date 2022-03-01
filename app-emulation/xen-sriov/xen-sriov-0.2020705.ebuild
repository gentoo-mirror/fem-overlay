# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRIOV_COMMIT="365fb06e0ba158b46773bd5d4978878383f2ebcc"

MY_PN="${PN}-scripts"
MY_P="${MY_PN}-${SRIOV_COMMIT}"

inherit udev

DESCRIPTION="Xen sr-iov scripts"
HOMEPAGE="https://gitlab.fem-net.de/technik/xen/xen-sriov-scripts"
SRC_URI="https://gitlab.fem-net.de/technik/xen/xen-sriov-scripts/-/archive/${SRIOV_COMMIT}/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/udev"
RDEPEND="
	${DEPEND}
	app-emulation/xen-tools
"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	exeinto /usr/bin
	doexe scripts/*
	doinitd init.d/xen-sriov
	doconfd conf.d/xen-sriov
	udev_dorules 85-xen-sriov.rules
}
