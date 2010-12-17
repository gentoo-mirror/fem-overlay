# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python git autotools

DESCRIPTION="a collection of Linux tools written in C for interfacing to the Nintendo Wiimote"
HOMEPAGE="http://http://abstrakraft.org/cwiid/wiki"

EGIT_REPO_URI="git://github.com/abstrakraft/cwiid"
#EGIT_COMMIT="master"
#EGIT_BRANCH="${EGIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.20.1-r1
	dev-libs/glib
	>=net-wireless/bluez-4.77
	sys-kernel/linux-headers"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	git_submodules init
	git_submodules update
}

src_configure() {
	eaclocal
	eautoconf
	econf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
