# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/glusterfs/Attic/glusterfs-3.0.5.ebuild,v 1.2 2010/10/14 17:09:18 xarthisius dead $

EAPI="2"

inherit autotools elisp-common eutils multilib versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"
SRC_URI="http://ftp.gluster.com/pub/gluster/${PN}/$(get_version_component_range '1-2')/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs +fuse infiniband static-libs vim-syntax extras"

DEPEND="emacs? ( virtual/emacs )
		fuse? ( >=sys-fs/fuse-2.7.0 )
		infiniband? ( sys-infiniband/libibverbs )
		sys-devel/flex"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-mode-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.0.8-parallel-make.patch" \
		"${FILESDIR}/${PN}-2.0.8-docdir.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable fuse fuse-client) \
		$(use_enable infiniband ibverbs) \
		$(use_enable static-libs static) \
		--disable-bdb \
		--docdir=/usr/share/doc/${PF} \
		--localstatedir=/var
}

src_compile() {
	emake || die
	if use emacs ; then
		elisp-compile extras/glusterfs-mode.el || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use emacs ; then
		elisp-install ${PN} extras/glusterfs-mode.el* || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}/glusterfs.vim" || die
		insinto /usr/share/vim/vimfiles/syntax; doins extras/glusterfs.vim || die
	fi

	if use extras ; then
		newbin extras/volgen/glusterfs-volgen glusterfs-volgen || die
		newbin extras/backend-xattr-sanitize.sh glusterfs-backend-xattr-sanitize || die
		newbin extras/migrate-unify-to-distribute.sh glusterfs-migrate-unify-to-distribute || die
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS || die

	newinitd "${FILESDIR}/${PN}.initd" glusterfsd || die
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd || die

	keepdir /var/log/${PN} || die
}

pkg_postinst() {
	elog "The glusterfs startup script can be multiplexed."
	elog "The default startup script uses /etc/conf.d/glusterfs to configure the"
	elog "separate service.  To create additional instances of the glusterfs service"
	elog "simply create a symlink to the glusterfs startup script."
	elog
	elog "Example:"
	elog "    # ln -s glusterfsd /etc/init.d/glusterfsd2"
	elog "    # ${EDITOR} /etc/glusterfs/glusterfsd2.vol"
	elog "You can now treat glusterfsd2 like any other service"
	echo
	elog "You can mount exported GlusterFS filesystems through /etc/fstab instead of"
	elog "through a startup script instance.  For more information visit:"
	elog "http://www.gluster.org/docs/index.php/Mounting_a_GlusterFS_Volume"
	echo
	ewarn "You need to use a ntp client to keep the clocks synchronized across all"
	ewarn "of your servers.  Setup a NTP synchronizing service before attempting to"
	ewarn "run GlusterFS."

	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
