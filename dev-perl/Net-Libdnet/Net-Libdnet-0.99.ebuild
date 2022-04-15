# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Perl binding for libdnet"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Gomor
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
