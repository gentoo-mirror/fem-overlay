# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

EGIT_REPO_URI="git://git.universe-factory.net/libuecc.git"

inherit cmake-utils
[[ ${PV} == *9999* ]] && inherit git-2

DESCRIPTION="Very small elliptic curve cryptography library"
HOMEPAGE="http://git.universe-factory.net/libuecc/"
[[ ${PV} == *9999* ]] || \
SRC_URI="http://git.universe-factory.net/libuecc/snapshot/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~s390 ~sh ~sparc ~x86"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}
