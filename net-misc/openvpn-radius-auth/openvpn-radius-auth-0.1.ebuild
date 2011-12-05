# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A auth radiusplugin for openvpn with vlan support."
HOMEPAGE=""
SRC_URI="http://subversion.fem.tu-ilmenau.de/repository/fem-overlay/trunk/net-misc/${PN}/files/${PN}-0.1.tar.bz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

EAPI=4

RDEPEND=">=net-dialup/radiusclient-ng-0.5.6[add_tunel]
	 >=net-misc/openvpn-testing-vlan-9999[no_priority]"

DEPEND="${RDEPEND}"

src_compile() {
	emake || die "Error: emake failed!"
}

src_install() {
    emake DESTDIR="${D}" install || die
}
