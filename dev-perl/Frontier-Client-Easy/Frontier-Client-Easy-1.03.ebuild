# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DFREEDMAN"
inherit perl-module

DESCRIPTION="Perl extension for easy use of Frontier::Client"

#LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Frontier-RPC
"
DEPEND="${RDEPEND}"
