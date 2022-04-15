# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="BLUET"
inherit perl-module

DESCRIPTION="Non-blocking XMLRPC server"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/AnyEvent-HTTPD
	dev-perl/common-sense
	dev-perl/Frontier-RPC
"
DEPEND="${RDEPEND}"
