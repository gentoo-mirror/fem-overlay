# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/gitolite/gitolite-2.3.ebuild,v 1.1 2012/02/15 22:16:17 idl0r Exp $

EAPI=4

inherit eutils perl-module git-2

DESCRIPTION="Highly flexible server for git directory version tracker"
HOMEPAGE="http://github.com/sitaramc/gitolite"

EGIT_REPO_URI="https://github.com/sitaramc/gitolite"
EGIT_BRANCH="g3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-vcs/git-1.6.6"
RDEPEND="${DEPEND}
	!dev-vcs/gitolite-gentoo"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/sh /var/lib/gitolite git
}

src_install() {
	insinto "${VENDOR_LIB}"
	doins -r src/Gitolite || die
	rm -r src/Gitolite

	exeinto /usr/libexec/gitolite || die
	doexe src/gitolite* || die
	
	for dir in VREF commands triggers triggers/post-compile syntactic-sugar; do
	    exeinto /usr/libexec/gitolite/${dir} || die
	    doexe src/${dir}/*
	done
	
	dosym /usr/libexec/gitolite/gitolite /usr/bin/gitolite

	dodoc -r doc/*
	dodoc "${FILESDIR}/gitweb_config.perl"

	keepdir /var/lib/gitolite
	fowners git:git /var/lib/gitolite
	fperms 750 /var/lib/gitolite
}

pkg_postinst() {
	# bug 352291
	ewarn
	elog "Please make sure that your 'git' user has the correct homedir (/var/lib/gitolite)."
	elog "Especially if you're migrating from gitosis."
	elog ""
	elog "Please run as user git: gitolite setup -pk <yourname>.pub"
	elog ""
	elog "For using gitweb with gitolite, see provided gitweb_config.perl"
	ewarn
}
