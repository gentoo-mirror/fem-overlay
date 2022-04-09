# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module git-r3

DESCRIPTION="Utility to push metrics scraped from prometheus into graphite."
HOMEPAGE="https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay.git"

LICENSE="ISC MIT Apache-2.0 BSD"
SLOT="0"

if [[ ${PV} != *9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND=""
RDEPEND="
	acct-user/prometheus-graphite-relay
	acct-group/prometheus-graphite-relay
"
BDEPEND="dev-lang/go"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	ego build -v -work -x
}

src_install() {
	default
	exeinto /usr/bin/
	doexe ${PN}

	insinto /etc/
	newins dist/relay.toml ${PN}.toml

	newinitd dist/relay.initd ${PN}
}
