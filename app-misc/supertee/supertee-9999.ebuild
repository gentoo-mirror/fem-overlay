# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/tpipe/tpipe-1.6.ebuild,v 1.5 2009/12/25 02:26:07 darkside Exp $

inherit mercurial cmake-utils

DESCRIPTION="Multithreaded multisink pipe"
HOMEPAGE="http://hg.fem.tu-ilmenau.de/supertee"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

EAPI="2"

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

