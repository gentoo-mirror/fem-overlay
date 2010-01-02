# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=1

inherit eutils

DESCRIPTION="Additional Nagios plugins for monitoring SNMP capable devices"
HOMEPAGE="http://my-plugin.de/check_multi"
SRC_URI="http://my-plugin.de/check_multi/check_multi-${PV}.current.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="contrib examples"

DEPEND=""

RDEPEND="${DEPEND}
	>=dev-lang/perl-5.6.1-r7
	net-analyzer/nagios-plugins
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes
	contrib? ( virtual/perl-CGI )"

S=${WORKDIR}/check_multi-${PV}

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# patch Makefiles
	epatch "${FILESDIR}/${P}-subst.patch"
	use examples && epatch "${FILESDIR}/${P}-examples.patch"
}

src_compile() {
	econf \
		--prefix=/usr \
		--sbindir=/usr/$(get_libdir)/nagios/cgi-bin \
		--datarootdir=/usr/share/nagios/htdocs/docs \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins/contrib \
		--sysconfdir=/etc/nagios || die "econf failed"

	emake all || die "emake failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	
	use contrib && ( emake DESTDIR="${D}" install-contrib || die "make install-contrib failed" )
	use examples && emake DESTDIR="${D}" install-config || die "make install-config failed"

	dodoc Changelog README THANKS
}

pkg_postinst() {
	einfo "For more information about the Nagios-plugin \"check_multi\""
	einfo "look at the project-page from the author:"
	einfo ""
	einfo "   http://my-plugin.de/check_multi"
	if use examples; then
		einfo ""
		einfo "Example configuration is installed into /etc/nagios/check_multi"
	fi
	if use contrib; then
		einfo ""
		einfo "All contributions are installed into /usr/$(get_libdir)/nagios/plugins/contrib"
	fi
}

