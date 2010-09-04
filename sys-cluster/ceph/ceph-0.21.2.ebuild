# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="Ceph is an open source distributed file system capable of managing many petabytes of storage with ease."
HOMEPAGE="http://ceph.newdream.net/"
SRC_URI="http://ceph.newdream.net/download/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="fuse"

DEPEND="dev-libs/boost
		dev-libs/libedit"
RDEPEND="sys-fs/btrfs-progs"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with fuse)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install Failed"
	keepdir /var/lib/ceph
	keepdir /var/log/ceph

	newinitd "${FILESDIR}/ceph.init" ceph
	newconfd "${FILESDIR}/ceph.conf" ceph
}

pkg_postinst() {
	elog "To use this node as master, add the line "
	elog "  NODE=\"master\" "
	elog "in /etc/conf.d/ceph "
	elog
	ewarn " WARNING: Ceph is still under heavy development, and is only suitable for * "
	ewarn "          testing and review.  Do not trust it with important data.       * "
	elog
}
