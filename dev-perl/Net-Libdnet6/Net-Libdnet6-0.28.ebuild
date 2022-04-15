# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Add IPv6 support to Net::Libdnet"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Net-IPv6Addr
	dev-perl/Net-Libdnet
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
