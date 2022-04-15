# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="ETHER"
inherit perl-module

DESCRIPTION="Perl module to look up the vendor of a MAC"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/IO-Socket-SSL
	dev-perl/Mojolicious
	dev-perl/Net-SSLeay
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}"
