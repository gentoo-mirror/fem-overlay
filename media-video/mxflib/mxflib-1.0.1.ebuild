# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

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
	eautoreconf
}
