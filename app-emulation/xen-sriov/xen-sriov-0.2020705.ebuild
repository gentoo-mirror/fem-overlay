# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 udev

DESCRIPTION="Xen sr-iov scripts"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/projects/TEC/repos/xen-sriov-scripts"
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/tec/xen-sriov-scripts.git"
EGIT_COMMIT="365fb06e0ba158b46773bd5d4978878383f2ebcc"

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

src_install() {
	exeinto /usr/bin
	doexe scripts/*
	doinitd init.d/xen-sriov
	doconfd conf.d/xen-sriov
	udev_dorules 85-xen-sriov.rules
}
