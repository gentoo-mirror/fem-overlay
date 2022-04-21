# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="OLIVER"
inherit perl-module

DESCRIPTION="Perl extension for representing and manipulating MAC addresses"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}"

# Test requires Test::More which doesn't exist in ::gentoo nor ::fem-overlay
RESTRICT="test"
