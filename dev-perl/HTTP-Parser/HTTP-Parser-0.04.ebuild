# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="parse HTTP/1.1 request into HTTP::Request/Response object"

SRC_URI="mirror://cpan/authors/id/D/DB/DBROBINS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dbrobins/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

DEPEND="dev-perl/URI
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
}

