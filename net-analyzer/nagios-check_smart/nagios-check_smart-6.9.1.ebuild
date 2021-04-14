# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nagios Plugin to check hdds, ssds and NVMe drives using SMART"
HOMEPAGE="https://www.claudiokuenzler.com/monitoring-plugins/check_smart.php"
SRC_URI="https://github.com/Napsty/check_smart/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="
	${DEPEND}
	acct-group/nagios
	acct-user/nagios
	sys-apps/smartmontools
	virtual/perl-Getopt-Long
"
S=${WORKDIR}/check_smart-${PV}

src_install() {
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe check_smart.pl
}
