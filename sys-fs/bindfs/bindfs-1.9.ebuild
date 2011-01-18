# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

inherit eutils

DESCRIPTION="Fuse-filesystem similar to mount --bind."
SRC_URI="http://bindfs.googlecode.com/files/bindfs-${PV}.tar.gz"
HOMEPAGE="http://code.google.com/p/bindfs/"
LICENSE="GPL-2"

DEPEND="sys-fs/fuse"
RDEPEND="${DEPEND}"

KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

src_install() {
        emake DESTDIR="${D}" install || die "emake install failed"
        dodoc README ChangeLog
}

