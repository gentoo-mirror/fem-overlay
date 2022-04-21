# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Another class and object builder"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Data-Dumper
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
