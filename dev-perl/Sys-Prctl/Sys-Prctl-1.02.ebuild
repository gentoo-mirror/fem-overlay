# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="TLBDK"
inherit perl-module

DESCRIPTION="Perl module to access prctl syscall"

#LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"

PATCHES=(
	"${FILESDIR}/${P}-remove-broken-tests.patch"
)
