# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="a HTTP user-agent component"

SRC_URI="mirror://cpan/authors/id/R/RC/RCAPUTO/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rcaputo/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

myconf="${myconf} --noprompt"

DEPEND="dev-perl/POE
	>=virtual/perl-Module-Build-0.28
	dev-lang/perl
	dev-perl/URI
	dev-perl/libwww-perl
	dev-perl/POE-Component-Client-Keepalive
	dev-perl/Test-POE-Server-TCP"

src_unpack() {
	unpack ${A}
	cd ${S}
}

