# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="SVN::Notify - Subversion activity notification"
SRC_URI="mirror://cpan/authors/id/D/DW/DWHEELER/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/D/DW/DWHEELER/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86
~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos
~x86-macos"
IUSE=""

DEPEND=">=dev-vcs/subversion-1.1.3
	dev-perl/HTML-Parser
	virtual/perl-Getopt-Long
	virtual/perl-libnet
	virtual/perl-Module-Build"

RDEPEND="${DEPEND}"

pkg_setup() {
	if ! perl -MSVN::Core < /dev/null 2> /dev/null
	then
		eerror "You need subversion-1.0.4+ compiled with Perl bindings."
		eerror "USE=\"perl\" emerge subversion"
		die "Need Subversion compiled with Perl bindings."
	fi
}
