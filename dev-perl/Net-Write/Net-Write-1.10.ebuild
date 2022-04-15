# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Interface to open and send raw data to network"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Gomor
	dev-perl/Net-Pcap
	dev-perl/Socket-GetAddrInfo
	virtual/perl-Socket
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
