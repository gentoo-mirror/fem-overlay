# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="get network device information and gateway"

SRC_URI="mirror://cpan/authors/id/G/GO/GOMOR/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gomor/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

DEPEND="dev-perl/Socket6
	dev-perl/Bit-Vector
	dev-perl/Net-Frame
	dev-perl/Net-Frame-Dump
	dev-perl/Net-Frame-Simple
	dev-perl/Net-Frame-Layer-ICMPv6
	dev-perl/Net-Frame-Layer-IPv6
	dev-perl/Net-Pcap
	dev-perl/Net-Write	
	dev-perl/Net-Libdnet6
	dev-perl/Net-IPv4Addr
	dev-perl/Net-IPv6Addr
	dev-perl/Class-Gomor	
	>=virtual/perl-Module-Build-0.28
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
}

