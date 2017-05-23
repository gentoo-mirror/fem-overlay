# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="SVN::Notify - Subversion activity notification"
SRC_URI="mirror://cpan/authors/id/D/DW/DWHEELER/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dwheeler/SVN-Notify/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86
~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=">=dev-vcs/subversion-1.1.3
	dev-perl/Email-Address
	dev-perl/HTML-Parser
	dev-perl/Module-Build
	virtual/perl-Getopt-Long
	virtual/perl-libnet"

RDEPEND="${DEPEND}"

pkg_setup() {
	if ! perl -MSVN::Core < /dev/null 2> /dev/null
	then
		eerror "You need subversion-1.0.4+ compiled with Perl bindings."
		eerror "USE=\"perl\" emerge subversion"
		die "Need Subversion compiled with Perl bindings."
	fi
}
