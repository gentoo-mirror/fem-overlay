# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/pgadmin3/pgadmin3-1.8.4.ebuild,v 1.2 2008/07/18 08:11:51 aballier Exp $

EAPI="2"

WX_GTK_VER="2.8"

inherit wxwidgets eutils

KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"

MY_PV=${PV/_/-}
MY_P=${PN}-${MY_PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="wxWidgets GUI for PostgreSQL."
HOMEPAGE="http://www.pgadmin.org/"
SRC_URI="mirror://postgresql/pgadmin3/release/v${MY_PV}/src/${MY_P}.tar.gz"
LICENSE="Artistic"
SLOT="0"
IUSE="debug"

DEPEND="x11-libs/wxGTK:2.8
	virtual/postgresql-base
	>=dev-libs/libxml2-2.6
	>=dev-libs/libxslt-1.1"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--with-wx-version=2.8 \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "einstall failed"

	insinto /usr/share/pixmaps
	newins "${S}/pgadmin/include/images/elephant48.xpm" pgadmin3.xpm

	insinto /usr/share/pgadmin3
	newins "${S}/pgadmin/include/images/elephant48.xpm" pgadmin3.xpm

	insinto /usr/share/applications
	doins "${S}/pkg/pgadmin3.desktop"

	# Fixing world-writable files
	chmod -R go-w "${D}/usr/share"
}
