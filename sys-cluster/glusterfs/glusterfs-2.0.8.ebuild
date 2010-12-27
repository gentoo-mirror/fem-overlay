# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/glusterfs/Attic/glusterfs-2.0.8.ebuild,v 1.5 2010/02/22 22:31:39 alexxy dead $

EAPI="2"

inherit autotools elisp-common eutils multilib versionator

DESCRIPTION="GlusterFS is a powerful network/cluster filesystem"
HOMEPAGE="http://www.gluster.org/"
SRC_URI="http://ftp.gluster.com/pub/gluster/${PN}/$(get_version_component_range '1-2')/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs +fuse infiniband static vim-syntax extras"
#IUSE="emacs +fuse infiniband static vim-syntax"

DEPEND="emacs? ( virtual/emacs )
		fuse? ( >=sys-fs/fuse-2.7.0 )
		infiniband? ( sys-infiniband/libibverbs )"
RDEPEND="${DEPEND}
		!net-fs/glusterfs"

SITEFILE="50${PN}-mode-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${P}-parallel-make.patch"
	epatch "${FILESDIR}/${P}-docdir.patch"
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf \
		$(use_enable fuse fuse-client) \
		$(use_enable infiniband ibverbs) \
		$(use_enable static) \
		--disable-bdb \
		--docdir=/usr/share/doc/${PF} \
		--localstatedir=/var || die
#		$(use_enable berkdb bdb) \
}

src_compile() {
	emake || die "Emake failed"
	if use emacs ; then
		elisp-compile extras/glusterfs-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use emacs ; then
		elisp-install ${PN} extras/glusterfs-mode.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect; doins "${FILESDIR}/glusterfs.vim" || die
		insinto /usr/share/vim/vimfiles/syntax; doins extras/glusterfs.vim || die
	fi

	if use extras ; then
		newbin extras/glusterfs-volgen glusterfs-volgen || die "Failed to install bins"
		newbin extras/backend-xattr-sanitize.sh glusterfs-backend-xattr-sanitize || die "Failed to install bins"
		newbin extras/migrate-unify-to-distribute.sh glusterfs-migrate-unify-to-distribute || die "Failed to install bins"
	fi

	dodoc AUTHORS ChangeLog NEWS README THANKS || die "dodoc failed"

	newinitd "${FILESDIR}/${PN}.initd" glusterfsd || die "newinitd failed"
	newconfd "${FILESDIR}/${PN}.confd" glusterfsd || die "newconfd failed"

	keepdir /var/log/${PN} || die "keepdir failed"
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
