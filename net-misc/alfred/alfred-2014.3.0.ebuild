# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Almighty Lightweight Fact Remote Exchange Daemon"
HOMEPAGE="http://www.open-mesh.org/projects/open-mesh/wiki/Alfred"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://git.open-mesh.org/alfred.git"
	KEYWORDS=""
else
	SRC_URI="http://downloads.open-mesh.org/batman/stable/sources/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gps"

DEPEND="gps? ( sci-geosciences/gpsd )"

EMAKE_OPTS=""

src_compile() {
	if ! use gps; then
		EMAKE_OPTS="CONFIG_ALFRED_GPSD=n"
	fi

	emake ${EMAKE_OPTS}
}

src_install() {
	emake ${EMAKE_OPTS} PREFIX="${D}"/usr install
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}
	dodoc README CHANGELOG
}
