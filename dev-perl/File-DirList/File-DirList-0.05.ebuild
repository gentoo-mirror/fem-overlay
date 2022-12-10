# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_A="${PN}/${P}.tar.gz"
DIST_AUTHOR="TPABA"
inherit perl-module

DESCRIPTION="Provide a sorted list of directory content"

SLOT="0"
KEYWORDS="amd64"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
