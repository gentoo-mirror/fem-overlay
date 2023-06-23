# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Long term prometheus metrics storage"
HOMEPAGE="https://grafana.com/oss/mimir/"
SRC_URI="https://github.com/grafana/mimir/releases/download/${MY_P}/${MY_P}_amd64.deb"

# AGPL-3 for mimir, rest extracted using dev-go/lichen
LICENSE="AGPL-3 Apache-2.0 BSD-2 BSD ISC LGPL-3 MIT MPL-2.0"
SLOT="0"
KEYWORDS="-* amd64"

RDEPEND="
	acct-user/mimir
	acct-group/mimir
"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${PN}-systemd-paths.patch"
)

QA_PREBUILT="*"

src_unpack() {
	default

	tar -xf data.tar* || die
	gunzip "usr/share/doc/mimir/changelog.gz" || die
}

src_install() {
	dobin "usr/local/bin/mimir"
	dodoc "usr/share/doc/mimir/changelog"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate.conf" "${MY_PN}.conf"

	newinitd "${FILESDIR}/${MY_PN}-initd-r1" "${MY_PN}"
	newconfd "etc/default/mimir" "${MY_PN}"

	systemd_dounit "lib/systemd/system/${MY_PN}.service"
}
