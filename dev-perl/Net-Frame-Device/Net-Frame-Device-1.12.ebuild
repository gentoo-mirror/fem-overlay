# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Get network device information and gateway"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Gomor
	dev-perl/Net-Frame
	dev-perl/Net-Frame-Dump
	dev-perl/Net-Frame-Layer-ICMPv6
	dev-perl/Net-Frame-Layer-IPv6
	dev-perl/Net-Frame-Simple
	dev-perl/Net-IPv4Addr
	dev-perl/Net-IPv6Addr
	dev-perl/Net-Libdnet
	dev-perl/Net-Libdnet6
	dev-perl/Net-Pcap
	dev-perl/Net-Write
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"

src_prepare() {
	# These tests require don't work with FEATURES=network-sandbox
	rm t/04-new-default.t t/05-new-target.t || die

	perl-module_src_prepare
}
