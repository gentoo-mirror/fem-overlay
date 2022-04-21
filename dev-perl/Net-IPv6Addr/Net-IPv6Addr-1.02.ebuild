# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="BKB"
inherit perl-module

DESCRIPTION="Module to check and manipulate IPv6 addresses"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Math-BigInt
	virtual/perl-Carp
"
DEPEND="${RDEPEND}"
