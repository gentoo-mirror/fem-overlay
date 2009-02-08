# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE="test-streaming ssl prefork"

inherit perl-module eutils

DESCRIPTION="Perl extension to serve HTTP requests in POE"

SRC_URI="mirror://cpan/authors/id/B/BI/BINGOS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~bingos/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
SRC_TEST="do"
PATCHES="${FILESDIR}/ask-1.48.patch"

DEPEND="dev-perl/SOAP-Lite
	dev-perl/POE-Filter-HTTP-Parser
	dev-perl/Test-POE-Client-TCP
	dev-perl/POE-Filter-HTTP-Parser
	dev-perl/Test-POE-Client-TCP
	prefork? ( dev-perl/IPC-Shareable )
	ssl? ( dev-perl/POE-Component-SSLify )
	test-streaming? ( dev-perl/POE-Component-Client-HTTP )
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${PATCHES}
}
