# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="PgRouting library"
HOMEPAGE="http://www.postlbs.org"
SRC_URI="http://files.postlbs.org/pgrouting/source/pgRouting-1.03.tgz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=virtual/postgresql-server-8.4
	>=dev-libs/boost-1.33.0
	sci-libs/geos
	sci-libs/proj
	dev-db/postgis
	sci-mathematics/cgal
	>=sci-libs/gaul-devel-0.1489"

S="${WORKDIR}/pgrouting"

CMAKE_IN_SOURCE_BUILD=1

src_unpack(){
	unpack ${A}
	epatch "${FILESDIR}"/pgrouting-1.0.3-postgresql-8.4.patch
}

src_compile(){
	cd ${S}
	cmake-utils_src_configure
	cmake-utils_src_compile
}

src_install(){
	cmake-utils_src_install

	ewarn ""
	ewarn "To add routing functinality to your database add:"
	ewarn ""
	ewarn "psql -U postgres -f /usr/share/postlbs/routing_core.sql database"
	ewarn "psql -U postgres -f /usr/share/postlbs/routing_core_wrappers.sql database"
	ewarn "psql -U postgres -f /usr/share/postlbs/routing_topology.sql database"
	ewarn ""
}
