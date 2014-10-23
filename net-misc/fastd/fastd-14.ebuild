# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="git://git.universe-factory.net/fastd.git"

inherit cmake-utils
[[ ${PV} == *9999* ]] && inherit git-2

DESCRIPTION="Fast and secure tunneling daemon with very small binary"
HOMEPAGE="https://projects.universe-factory.net/projects/fastd/wiki"
[[ ${PV} == *9999* ]] || \
SRC_URI="http://git.universe-factory.net/fastd/snapshot/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~alpha ~amd64 ~amd64-fbsd ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"

RDEPEND="
	sys-libs/libcap
	dev-libs/libsodium
	>=dev-libs/libuecc-4
"

DEPEND="
	>=sys-devel/bison-2.5.0
	dev-util/cmake
	virtual/pkgconfig
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die
	emake DESTDIR="${D}" install
	cd "${S}" || die
	dodoc README COPYRIGHT
	doman doc/fastd.1
}
