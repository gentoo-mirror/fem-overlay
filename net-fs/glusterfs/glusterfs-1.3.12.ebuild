# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils versionator

DESCRIPTION="GlusterFS is a clustered file-system in userspace."
HOMEPAGE="http://gluster.org/glusterfs.php"
SRC_URI="http://ftp.zresearch.com/pub/gluster/${PN}/$(get_version_component_range 1-2)/${PV}/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
DEPEND="sys-devel/flex
	sys-devel/bison
	client? ( >=sys-fs/fuse-2.6.3 )"
RDEPEND="${DEPEND}"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="client infiniband"

pkg_setup() {
	if use infiniband ; then
		if [[ ! -e "${ROOT}/usr/include/infiniband/verbs.h" ]] ; then
			ewarn
			ewarn "libibverbs (>=1.0.4) is needed to build the ib-verbs transport"
			ewarn "(Infiniband support). Download and install it from http://openib.org/ or"
			ewarn "install ebuild from Gentoo Bug #188412 (if package is not in main tree)."
			ewarn
			die ">=libibverbs-1.0.4 is needed"
		fi
	fi
}

src_compile() {
	./autogen.sh
	econf \
		--prefix=/ \
		--exec-prefix=/usr \
		--localstatedir=/var \
		$(use_enable client fuse-client) \
		$(use_enable infiniband ibverbs) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc doc/examples/*.vol
	dodir /usr/include/glusterfs
	insinto /usr/include/glusterfs
	doins libglusterfs/src/*.h
	dodir /var/log/glusterfs
	newinitd "${FILESDIR}/glusterfs-server.initd" glusterfs-server
	newconfd "${FILESDIR}/glusterfs-server.confd" glusterfs-server 
	if use client; then
		newinitd "${FILESDIR}/glusterfs-client.initd" glusterfs-client
		newconfd "${FILESDIR}/glusterfs-client.confd" glusterfs-client
	fi
}
