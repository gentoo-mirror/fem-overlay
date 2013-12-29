# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="TK Suite Server for AGFEO telecommunication systems"
HOMEPAGE="http://www.agfeo.de"
SRC_URI="ftp://ftp.agfeo.de/pub/software/tksuite_agfeo_${PV}_linux-x86.tgz"
LICENSE="all-rights-reserved"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/tksuite_agfeo_${PV}_linux-x86/tksuite_server

QA_TEXTRELS_amd64="opt/tksuite-server/libtkmedia.so"

QA_PRESTRIPPED="opt/tksuite-server/tksock
	opt/tksuite-server/tkmedia_xport.so
	opt/tksuite-server/tkmedia_serial.so
	opt/tksuite-server/tkmedia_capi.so
	opt/tksuite-server/tkmedia
	opt/tksuite-server/libtkmedia.so"

src_prepare() {
#	unpack ${A}
#	cd "${S}"

	# Fix var-path
	sed -i \
		-e "s:/var/tksuite_server:/var/tksuite-server:" \
		defaults.cfg
}

src_install() {
	# Install binary stuff and documentation
	dodir /opt/tksuite-server
	insinto /opt/tksuite-server
	doins -r *
	dodoc ../readme.txt

	# add env.d-file for CONFIG_PROTECT
	doenvd "${FILESDIR}"/99tksuite-server

	# Create /var hierarchy, tksock.ini and update.xml
	dodir /var/tksuite-server/ \
		  /var/tksuite-server/dbf \
		  /var/tksuite-server/files \
		  /var/tksuite-server/images \
		  /var/tksuite-server/updates
	insinto /var/tksuite-server
	doins "${FILESDIR}"/tksock.ini
	newins update.xml.default update.xml

	# Install init-script
	newinitd "${FILESDIR}"/tksuite-server.init tksuite-server
}

pkg_postinst() {
	einfo "To start Agfeo TK-Suite Server please run"
	einfo ""
	einfo "   /etc/init.d/tksuite-server start"
	einfo ""
	einfo "Afterwards you can configure TK-Suite Server using"
	einfo "your web-browser with the following URL"
	einfo ""
	einfo "   http://localhost:5080/tkset"
	einfo ""
	einfo "with username \"admin\" without password."
	einfo ""
	einfo "For further information please consider readme.txt"
	einfo "in /usr/share/doc/${PF}."
	einfo ""
}
