# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GO_FEM_DEP_ARCHIVE_VER=2022-07-09
inherit go-module-fem

go-module_set_globals

DESCRIPTION="Utility to push metrics scraped from prometheus into graphite."
HOMEPAGE="https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay"
SRC_URI="
	https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay/-/archive/v${PV}/prometheus-graphite-relay-v${PV}.tar.bz2
	${GO_FEM_SRC_URI}
"

LICENSE="ISC MIT BSD Apache-2.0"
SLOT="0"

if [[ ${PV} != *9999 ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND=""
RDEPEND="
	acct-user/prometheus-graphite-relay
	acct-group/prometheus-graphite-relay
"

S="${WORKDIR}/${PN}-v${PV}"

src_install() {
	default
	exeinto /usr/bin/
	doexe ${PN}

	insinto /etc/
	newins dist/relay.toml ${PN}.toml

	newinitd dist/relay.initd ${PN}
}
