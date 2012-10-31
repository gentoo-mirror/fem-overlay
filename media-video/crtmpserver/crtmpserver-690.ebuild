# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils

DESCRIPTION="Crtmpserver ( rtmpd )  it is a high performance streaming server"
HOMEPAGE="http://rtmpd.org/"
SRC_URI="http://rtmpd.org/assets/sources/crtmpserver-690.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/lua
	dev-libs/openssl
	dev-libs/tinyxml"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/builders/cmake"

CMAKE_IN_SOURCE_BUILD=1

src_prepare() {
    make clean
}

src_configure() {
    CMAKE_BUILD_TYPE="Debug"
    cmake -DCRTMPSERVER_INSTALL_PREFIX=/usr/local/rtmpd
}

src_compile() {
   emake || die "emake failed"
}

