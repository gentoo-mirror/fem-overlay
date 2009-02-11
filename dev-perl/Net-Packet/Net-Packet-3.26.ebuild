# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="a framework to easily send and receive frames from layer 2 to layer 7"

SRC_URI="mirror://cpan/authors/id/G/GO/GOMOR/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~gomor/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

DEPEND="dev-perl/Socket6
	perl-core/Time-HiRes
	dev-perl/Net-Pcap
	dev-perl/Bit-Vector
	>=virtual/perl-Module-Build-0.28
	dev-perl/Net-IPv6Addr
	dev-perl/Net-Libdnet
	dev-perl/Net-Write
	dev-perl/Class-Gomor	
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
}

