# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 user

SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/monitor/${PN}.git"

DESCRIPTION="Utility to push metrics scraped from prometheus into graphite."
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/projects/MONITOR/repos/prometheus-graphite-relay"
LICENSE="ISC"
SLOT="0"

if [[ ${PV} != *9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/go"

pkg_setup() {
	enewgroup prometheus-graphite-relay
	enewuser prometheus-graphite-relay -1 -1 -1 prometheus-graphite-relay
}

src_unpack() {
	git-r3_src_unpack

	# setup module dependencies
	cd "${S}"
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
