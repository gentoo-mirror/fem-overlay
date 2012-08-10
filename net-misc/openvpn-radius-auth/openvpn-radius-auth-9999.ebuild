# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
        SCM="subversion"
        ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/openvpn-radius-auth/trunk"
fi

inherit eutils flag-o-matic multilib toolchain-funcs ${SCM}

DESCRIPTION="A auth radiusplugin for openvpn with vlan support."
HOMEPAGE=""

if [ "${PV#9999}" != "${PV}" ] ; then
        SRC_URI=""
fi

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
EAPI=4

DEPEND=">=net-dialup/radiusclient-ng-0.5.6[add_tunnel]"

RDEPEND="${DEPEND}
        >=net-misc/openvpn-testing-vlan-9999[no_priority]"

src_compile() {
        emake || die "Error: emake failed!"
}

src_install() {
	insinto /usr/lib
	doins openvpn-radius-auth.so
}
