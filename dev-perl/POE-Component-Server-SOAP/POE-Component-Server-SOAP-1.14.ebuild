# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SOAP-Lite/SOAP-Lite-0.69.ebuild,v 1.9 2008/12/08 09:35:47 tove Exp $

IUSE=""

inherit perl-module eutils

DESCRIPTION="publish POE event handlers via SOAP over HTTP"

SRC_URI="mirror://cpan/authors/id/A/AP/APOCAL/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~apocal/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
SRC_TEST="do"

myconf="${myconf} --noprompt"

DEPEND="dev-perl/SOAP-Lite
	perl-core/Test-Simple
	dev-perl/POE
	dev-perl/POE-Component-Server-SimpleHTTP
	dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
}

