# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="SSL in the world of POE made easy"

SRC_URI="mirror://cpan/authors/id/A/AP/APOCAL/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~apocal/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

myconf="${myconf} --noprompt"

DEPEND="dev-perl/Net-SSLeay
	>=virtual/perl-Module-Build-0.28
	perl-core/Test-Simple
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
}

