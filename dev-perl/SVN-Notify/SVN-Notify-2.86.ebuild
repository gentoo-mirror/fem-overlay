# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-module

DESCRIPTION="SVN::Notify - Subversion activity notification"
SRC_URI="mirror://cpan/authors/id/D/DW/DWHEELER/${P}.tar.gz"
HOMEPAGE="https://search.cpan.org/~dwheeler/SVN-Notify/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86
~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=dev-vcs/subversion-1.1.3[perl]
	dev-perl/Email-Address
	dev-perl/HTML-Parser
	dev-perl/Module-Build
	virtual/perl-Getopt-Long
	virtual/perl-libnet"

RDEPEND="${DEPEND}"
