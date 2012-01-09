# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vde/vde-2.3.1.ebuild,v 1.2 2011/10/23 12:18:42 scarabeus Exp $

EAPI=4
inherit autotools fixheadtails eutils multilib subversion linux-mod

MY_P="${PN}2-${PV}"
S="${WORKDIR}/${MY_P}"


DESCRIPTION="AF_IPN: inter process networking, i.e. multipoint, multicast/broadcast communication among processes (and networks)"
ESVN_REPO_URI="https://vde.svn.sourceforge.net/svnroot/vde/trunk/ipn"
HOMEPAGE="http://vde.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {
	#libdir="extra/"
	BUILD_PARAMS="KERNELDIR=/lib/modules/${KV_FULL}/build"
	# BUILD_TARGETS="modules"
	MODULE_NAMES="ipn(extra:${KSRCDIR}:${KSRCDIR})"
	ebegin "Building IPN"
	if use kernel_linux; then
		linux-mod_src_compile
	fi
	eend $?
}

src_install() {
	if use kernel_linux; then
		linux-mod_src_install
	fi
}
