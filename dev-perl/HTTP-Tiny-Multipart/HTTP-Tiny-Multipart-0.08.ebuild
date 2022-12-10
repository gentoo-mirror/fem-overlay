# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="RENEEB"
inherit perl-module

DESCRIPTION="Add post_multipart to HTTP::Tiny"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-HTTP-Tiny
	virtual/perl-MIME-Base64
"
DEPEND="
	test? ( ${RDEPEND} )
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
"

RESTRICT="!test? ( test )"
