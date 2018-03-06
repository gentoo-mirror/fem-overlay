# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Convert hash to xml and xml to hash using LibXML"
HOMEPAGE="http://search.cpan.org/search?query=XML-Hash-LX&mode=dist"
SRC_URI="mirror://cpan/authors/id/M/MO/MONS/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64"

DEPEND=">=dev-perl/lib-abs-0.90
	dev-perl/XML-LibXML
	dev-lang/perl"
