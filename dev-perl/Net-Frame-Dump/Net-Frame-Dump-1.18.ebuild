# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Base-class for a tcpdump like implementation"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Gomor
	dev-perl/Net-Frame
	dev-perl/Net-Pcap
	virtual/perl-IO
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
