# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

HOMEPAGE="https://github.com/tcatm/ecdsautils"
SRC_URI="https://github.com/tcatm/ecdsautils/archive/v${PV}.tar.gz"

DESCRIPTION="Tiny collection of programs used for ECDSA (keygen, sign, verify)"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}
