# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#EAPI=0

inherit autotools eutils versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"

SLOT="0"
MY_PV="$(replace_version_separator '_' '')"
MY_P="${PN}-${MY_PV}"
MY_PV_1="$(get_version_component_range "1-2")"
MY_PV_2="$(get_version_component_range "1-3")"
SRC_URI="http://europe.gluster.org/${PN}/${MY_PV_1}/${MY_PV_2}/${MY_P}.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="fuse"

COMMON_DEPEND="fuse? ( >=sys-fs/fuse-2.7.3 )"
DEPEND="${COMMON_DEPEND}
	sys-devel/bison
	sys-devel/flex
"
RDEPEND="${COMMON_DEPEND}
	||	( net-misc/ntp net-misc/ntpclient )"
#	infiniband?	( sys-cluster/libibverbs )

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf \
	--disable-static \
	--disable-mod_glusterfs \
	$(use_enable fuse fuse-client) \
	--disable-bdb \
	--localstatedir=/var --docdir=/usr/share/doc/${PF}

	emake LIBTOOLFLAGS="--quiet" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" LIBTOOLFLAGS="--quiet" install -j1 || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README THANKS || die "dodoc failed"

	newinitd "${FILESDIR}/${PN}-1.3.10.initd" "${PN}" || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}-1.3.10.confd" "${PN}" || die "newconfd failed"

	keepdir /var/log/${PN} || die "keepdir failed"
}

pkg_postinst() {
	einfo "The glusterfs startup script can be multiplexed."
	einfo "The default startup script uses /etc/conf.d/glusterfs to configure the"
	einfo "separate service.  To create additional instances of the glusterfs service"
	einfo "simply create a symlink to the glusterfs startup script that is prefixed"
	einfo "with \"glusterfs.\""
	einfo
	einfo "Example:"
	einfo "    # cd /etc/init.d"
	einfo "    # ln -s glusterfs glusterfs.client"
	einfo "You can now treat glusterfs.client like any other service"
	echo
	einfo "You can mount exported GlusterFS filesystems through /etc/fstab instead of"
	einfo "through a startup script instance.  For more information visit:"
	einfo "http://www.gluster.org/docs/index.php/Mounting_a_GlusterFS_Volume"
	echo
	ewarn "You need to use a ntp client to keep the clocks synchronized across all"
	ewarn "of your servers.  Setup a NTP synchronizing service before attempting to"
	ewarn "run GlusterFS."
}
