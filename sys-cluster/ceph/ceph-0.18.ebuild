# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="a distributed network file system designed to provide excellent performance, reliability, and scalability"
HOMEPAGE="http://ceph.newdream.net/"
SRC_URI="http://ceph.newdream.net/download/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="fuse radosgw hadoop"

EAPI="2"

DEPEND="sys-fs/fuse
	dev-libs/libedit"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with fuse) \
#		$(use_with radosgw) \
#		$(use_with hadoop)
}

src_install() {
	emake DESTDIR="${D}" install || die
}