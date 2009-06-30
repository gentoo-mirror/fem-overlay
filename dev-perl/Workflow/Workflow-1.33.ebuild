# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="Simple, flexible system to implement workflows"

SRC_URI="mirror://cpan/authors/id/J/JO/JONASBN/${P}_3.tar.gz"
HOMEPAGE="http://search.cpan.org/~jonasbn/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

myconf="${myconf} --noprompt"

DEPEND="dev-lang/perl
	dev-perl/Class-Accessor
	dev-perl/Class-Factory
	dev-perl/Class-Observable	
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	dev-perl/Exception-Class
	dev-perl/log-dispatch
	dev-perl/Log-Log4perl
	dev-perl/XML-Simple
	dev-perl/DBI
	dev-perl/File-Slurp"

src_unpack() {
	unpack ${A}
	cd ${S}
}
