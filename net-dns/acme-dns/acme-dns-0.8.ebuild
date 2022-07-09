# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GO_FEM_DEP_ARCHIVE_VER=2022-07-09
inherit go-module-fem

go-module_set_globals

DESCRIPTION="Limited DNS server with RESTful API to handle ACME DNS challenges securely"
HOMEPAGE="https://github.com/joohoi/acme-dns"
SRC_URI="
	https://github.com/joohoi/acme-dns/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${GO_FEM_SRC_URI}
"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="
	${DEPEND}
	acct-user/acme-dns
	acct-group/acme-dns
	sys-libs/libcap
"
BDEPEND=""

EGO_PN="github.com/joohoi/acme-dns"

src_install() {
	insinto /etc/acme-dns
	doins config.cfg
	insinto /usr/lib/systemd
	doins acme-dns.service

	newconfd "${FILESDIR}"/${PN}-confd ${PN}
	newinitd "${FILESDIR}"/${PN}-initd ${PN}

	keepdir /var/lib/${PN}
}
