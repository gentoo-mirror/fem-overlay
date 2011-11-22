# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vde/vde-2.3.1.ebuild,v 1.2 2011/10/23 12:18:42 scarabeus Exp $

EAPI=4
inherit autotools fixheadtails eutils multilib subversion

MY_P="${PN}2-${PV}"
S="${WORKDIR}/${MY_P}"


DESCRIPTION="vde2 is a virtual distributed ethernet emulator for emulators like qemu, bochs, and uml."
ESVN_REPO_URI="https://vde.svn.sourceforge.net/svnroot/vde/trunk/vde-2"
ESVN_REVISION=510
HOMEPAGE="http://vde.sourceforge.net/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

IUSE="pcap ssl static-libs kernel-switch experimental"

RDEPEND="pcap? ( net-libs/libpcap )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

src_configure() {
	autoreconf -fi
	econf \
		$(use_enable pcap) \
		$(use_enable ssl cryptcab) \
		$(use_enable kernel-switch) \
		$(use_enable experimental) \
		$(use_enable static-libs static)
}

src_compile() {
	emake -j1
}

src_prepare() {
	epatch "${FILESDIR}/fixmemleak.diff"
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +

	newinitd "${FILESDIR}"/vde.init vde
	newconfd "${FILESDIR}"/vde.conf vde
}

pkg_postinst() {
	# default group already used in kqemu
	enewgroup qemu
	einfo "To start vde automatically add it to the default runlevel:"
	einfo "# rc-update add vde default"
	einfo "You need to setup tap0 in /etc/conf.d/net"
	einfo "To use it as an user be sure to set a group in /etc/conf.d/vde"
	einfo "Users of the group can then run: $ vdeq qemu -sock /var/run/vde.ctl ..other opts"
}
