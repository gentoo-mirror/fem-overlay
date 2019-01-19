# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="lib that makes relative path absolute to caller"
HOMEPAGE="http://search.cpan.org/search?query=lib-abs&mode=dist"
SRC_URI="mirror://cpan/authors/id/M/MO/MONS/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64"

PATCHES=("${FILESDIR}/perl-526.patch")
