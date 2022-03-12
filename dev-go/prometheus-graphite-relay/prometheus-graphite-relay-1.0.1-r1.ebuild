# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utility to push metrics scraped from prometheus into graphite."
HOMEPAGE="https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay"
SRC_URI="https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay/-/archive/v${PV}/prometheus-graphite-relay-v${PV}.tar.bz2"

LICENSE="ISC"
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
BDEPEND="dev-lang/go"

S="${WORKDIR}/${PN}-v${PV}"

src_unpack() {
	default
	# setup module dependencies
	cd "${S}" || die
	env GOCACHE="${T}/go-cache" \
		go mod download || die
}

src_compile() {
	env GOCACHE="${T}/go-cache" \
		go build -v -work -x || die
}

src_install() {
	default
	exeinto /usr/bin/
	doexe ${PN}

	insinto /etc/
	newins dist/relay.toml ${PN}.toml

	newinitd dist/relay.initd ${PN}
}
