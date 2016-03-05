# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="http://grafana.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz"
EGO_PN="github.com/${PN}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-lang/go-1.4
	dev-go/godep
	>=net-libs/nodejs-0.12"
RDEPEND="${DEPEND}"
S="${WORKDIR}/src/${EGO_PN}"

pkg_setup() {
	enewgroup grafana
	enewuser grafana -1 -1 -1 "grafana"
}

# unpack src to ${S}
src_unpack() {
	unpack ${A}
	mkdir -p "${S}"
	rm -d "${S}"
	mv "${P}" "${S}"
}

src_compile() {
	GOPATH=${WORKDIR} go run -v -work -x build.go setup  || die
	GOPATH=${WORKDIR} godep restore || die
	GOPATH="${WORKDIR}" go build -v -work -x . || die

	npm install --silent
	node -e "require('grunt').tasks(['default']);"
}

src_install() {
	dosbin grafana
	newinitd "${FILESDIR}/grafana.initd" grafana

	dodir /etc/grafana
	insinto /etc/grafana
	newins conf/sample.ini grafana.ini
	newins conf/ldap.toml ldap.toml

	dodir /usr/share/grafana/public
	cp -R "${S}"/public_gen/* "${D}"/usr/share/grafana/public || die
	dodir /usr/share/grafana/conf
	insinto /usr/share/grafana/conf
	doins conf/defaults.ini

	keepdir /var/log/grafana
	keepdir /var/lib/grafana

	fowners root:grafana /etc/grafana
	fowners grafana:grafana /usr/share/grafana
	fowners grafana:grafana /var/log/grafana
	fowners grafana:grafana /var/lib/grafana

	fperms u+rwX,g+r,g-wx,o-rwx /etc/grafana
	fperms ug+rwX,o-rwx /usr/share/grafana
	fperms ug+rwX,o-rwx /var/log/grafana
	fperms ug+rwX,o-rwx /var/lib/grafana
}
