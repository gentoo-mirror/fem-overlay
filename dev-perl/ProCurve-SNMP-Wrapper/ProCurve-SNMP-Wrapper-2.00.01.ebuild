# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

MY_P="admindb-vendored-perl-${P}"

DESCRIPTION="Perl SNMP wrapper for HP ProCurve switches"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://gitlab.fem-net.de/nex/admindb-vendored/-/archive/perl-${P}/${MY_P}.tar.bz2"

#LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Net-SNMP
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}/perl/${P}"
