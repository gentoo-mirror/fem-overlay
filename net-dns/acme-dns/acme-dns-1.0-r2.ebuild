# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_FEM_DEP_ARCHIVE_VER=2022-08-10
inherit check-reqs systemd go-module-fem

go-module_set_globals

DESCRIPTION="Limited DNS server with RESTful API to handle ACME DNS challenges securely"
HOMEPAGE="https://github.com/joohoi/acme-dns"
SRC_URI="
	https://github.com/joohoi/acme-dns/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${GO_FEM_SRC_URI}
"

LICENSE="MIT Apache-2.0 BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	acct-user/acme-dns
	acct-group/acme-dns
	sys-libs/libcap
"

EGO_PN="github.com/joohoi/acme-dns"

CHECKREQS_DISK_BUILD=1G

src_install() {
	go-module-fem_src_install

	insinto /etc/acme-dns
	doins config.cfg

	systemd_dounit acme-dns.service

	newconfd "${FILESDIR}/${PN}-confd" "${PN}"
	newinitd "${FILESDIR}/${PN}-initd-r2" "${PN}"

	keepdir "/var/lib/${PN}"
}
