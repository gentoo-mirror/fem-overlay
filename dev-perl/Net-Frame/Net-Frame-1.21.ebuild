# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Base framework for frame crafting"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Bit-Vector
	dev-perl/Class-Gomor
	dev-perl/Net-IPv6Addr
	virtual/perl-Socket
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"

src_prepare() {
	# Remove tests which require network access
	rm t/13-gethostsubs.t || die

	perl-module_src_prepare
}
