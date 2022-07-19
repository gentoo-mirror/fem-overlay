# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="No description available"
HOMEPAGE="https://search.cpan.org/search?query=XML-RPC-Fast&mode=dist"
SRC_URI="mirror://cpan/authors/id/M/MO/MONS/${P}.tar.gz"

IUSE="+curl +anyevent"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/lib-abs-0.90
	>=dev-perl/XML-Hash-LX-0.06
	dev-perl/Test-NoWarnings
	dev-perl/libwww-perl
	dev-perl/XML-LibXML
	curl? ( dev-perl/WWW-Curl )
	anyevent? ( dev-perl/AnyEvent-HTTP dev-perl/AnyEvent )
"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/perl-526.patch")
