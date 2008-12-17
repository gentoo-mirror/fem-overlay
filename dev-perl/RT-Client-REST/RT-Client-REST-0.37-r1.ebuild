# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=DMITRI
inherit perl-module

DESCRIPTION="A client library for perl5 to talk to RT installation using REST protocol"
LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl
	dev-perl/Test-Exception
	dev-perl/Params-Validate
	dev-perl/libwww-perl
	dev-perl/Exception-Class
	dev-perl/Error"

src_unpack() {
        unpack ${A}
        cd "${S}"
        epatch "${FILESDIR}"/rt-3.8.1_custom-fields.patch
}
