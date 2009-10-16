# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/flumotion/flumotion-0.5.3.ebuild,v 1.1 2009/02/13 11:48:58 deathwing00 Exp $

inherit eutils gnome2 autotools

DESCRIPTION="Flumotion Streaming server"
HOMEPAGE="http://www.flumotion.net"
SRC_URI="http://www.flumotion.net/src/flumotion/${P}.tar.bz2"
LICENSE="GPL-2"

KEYWORDS="~x86 ~amd64"
IUSE="v4l speex jpeg dv"
SLOT="0"
EAPI="0"

RDEPEND=">=x11-libs/gtk+-2.4
	>=dev-libs/glib-2.4
	>=gnome-base/libglade-2
	>=media-libs/gstreamer-0.10.11
	>=media-libs/gst-plugins-base-0.10.11
	=media-libs/gst-plugins-good-0.10*
	=media-plugins/gst-plugins-gnomevfs-0.10*
	=media-plugins/gst-plugins-ogg-0.10*
	=media-plugins/gst-plugins-theora-0.10*
	=media-plugins/gst-plugins-vorbis-0.10*
	=media-plugins/gst-plugins-libpng-0.10*
	=dev-python/gst-python-0.10*
	v4l? ( =media-plugins/gst-plugins-v4l-0.10* )
	speex? ( =media-plugins/gst-plugins-speex-0.10* )
	dv? ( =media-plugins/gst-plugins-dv-0.10*
	      =media-plugins/gst-plugins-raw1394-0.10* )
	>=dev-python/pygtk-2.8.6
	>=dev-python/twisted-2.0
	>=dev-python/twisted-web-0.5.0-r1
	>=dev-python/twisted-names-0.2.0
	dev-python/imaging
	dev-python/kiwi
	"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	"

DOCS="AUTHORS COPYING ChangeLog INSTALL \
	  LICENCE.Flumotion LICENCE.GPL \
	  NEWS README TODO"

src_compile() {
	gnome2_src_compile
	addpredict "$(unset HOME; echo ~)/.gconf"
	addpredict "$(unset HOME; echo ~)/.gconfd"
	mkdir -p "${T}/home"
	export HOME="${T}/home"
	export GST_REGISTRY=${T}/home/registry.cache.xml
	unset LINGUAS
	econf --localstatedir=/var || die

	emake || die
	# fix ${exec_prefix} not being expanded
	cd "${S}"/bin
	cp flumotion-manager flumotion-manager.orig
	sed -e 's:${exec_prefix}:/usr':g flumotion-manager.orig \
		> flumotion-manager
	cp flumotion-worker flumotion-worker.orig
	sed -e 's:${exec_prefix}:/usr':g flumotion-worker.orig \
		> flumotion-worker
	cp flumotion-admin flumotion-admin.orig
	sed -e 's:${exec_prefix}:/usr':g flumotion-admin.orig \
		> flumotion-admin
}

src_install() {
	einstall

	dodir /etc/flumotion
	dodir /etc/flumotion/managers
	dodir /etc/flumotion/managers/default
	dodir /etc/flumotion/managers/default/flows
	dodir /etc/flumotion/workers

	cd "${S}"/conf
	insinto /etc/flumotion/managers/default
	doins managers/default/planet.xml
	insinto /etc/flumotion/workers
	doins workers/default.xml

	insinto /etc/flumotion
	doins default.pem
	newinitd "${FILESDIR}"/flumotion-init-0.2.0 flumotion

	keepdir /var/run/flumotion
	keepdir /var/log/flumotion
}

pkg_postinst() {
	if ! enewgroup flumotion || ! enewuser flumotion -1 -1 /usr/share/flumotion flumotion,audio,video,sys; then
		die "Unable to add flumotion user and flumotion group."
	fi

	for dir in /usr/share/flumotion /var/log/flumotion /var/run/flumotion; do
		chown -R flumotion:flumotion "${dir}"
		chmod -R 755 "${dir}"
	done
}
