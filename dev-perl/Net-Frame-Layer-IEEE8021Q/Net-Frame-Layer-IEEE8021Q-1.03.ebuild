# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME="Net-Frame-Layer-8021Q"
DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="802.1Q layer object for Net::Frame"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Bit-Vector
	dev-perl/Net-Frame
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
