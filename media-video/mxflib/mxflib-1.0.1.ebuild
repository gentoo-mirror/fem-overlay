# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="A multi-platform C++ library for reading and writing MXF files"
HOMEPAGE="http://freemxf.org/"
ARCHIVE="MXF_`echo ${PV//./_}`"
SRC_URI="https://github.com/Tjoppen/mxflib/archive/${ARCHIVE}.tar.gz"

LICENSE="ZPL"
KEYWORDS="~amd64"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${ARCHIVE}"

src_prepare() {
	eapply_user
	eautoreconf
}
