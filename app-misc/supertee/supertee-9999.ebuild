# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="Multithreaded multisink pipe"
HOMEPAGE="https://stash.fem.tu-ilmenau.de/projects/ARCHIVE/repos/supertee"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-util/cmake
	dev-libs/boost"

EGIT_REPO_URI="https://pegro@stash.fem.tu-ilmenau.de/scm/archive/supertee.git"

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	dobin ${CMAKE_BUILD_DIR}/supertee
}
