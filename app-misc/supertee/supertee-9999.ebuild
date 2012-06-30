# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit mercurial cmake-utils

DESCRIPTION="Multithreaded multisink pipe"
HOMEPAGE="http://hg.fem.tu-ilmenau.de/supertee"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-util/cmake
	dev-libs/boost"

EHG_REPO_URI="http://hg.fem.tu-ilmenau.de/supertee"

S="${WORKDIR}/${PN}"

src_unpack() {
	mercurial_src_unpack
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin ${CMAKE_BUILD_DIR}/supertee
}
