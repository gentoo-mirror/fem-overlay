# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Open-Source implementation of RPKI to Router protocol"
HOMEPAGE="https://github.com/cloudflare/gortr"
SRC_URI="
	https://github.com/cloudflare/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	acct-user/gortr
	acct-group/gortr
"

DOCS=( "README.md" )

src_compile() {
	GOBIN=${S}/bin \
		emake build-gortr
}

src_install() {
	exeinto /usr/bin/
	cd dist || die
	mv "${PN}--linux-x86_64" "${PN}" || die
	doexe "${PN}"

	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
	newinitd "${FILESDIR}/${PN}-initd" "${PN}"
	keepdir /var/log/gortr

	einstalldocs
}
