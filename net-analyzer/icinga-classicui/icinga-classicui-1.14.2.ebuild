# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

#https://github.com/Icinga/icinga-core/blob/master/sample-config/cgi.cfg.in

EAPI=7

inherit eutils multilib pax-utils toolchain-funcs

DESCRIPTION="Icinca ClassicUI for Icinga2"
HOMEPAGE="http://www.icinga.org/"
#MY_PV=$(delete_version_separator 3)
#SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}.tar.gz"
#S=${WORKDIR}/${PN}-${MY_PV}
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
MY_PN="${PN/-classicui/}"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}-core/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+apache2 lighttpd"
DEPEND="
	acct-user/icinga
	acct-group/icinga

	media-libs/gd[jpeg,png]
	lighttpd? ( www-servers/lighttpd )

	net-analyzer/icinga2
	!net-analyzer/icinga[web]
	!net-analyzer/nagios-core
"
RDEPEND="${DEPEND}"
RESTRICT="test"

#want_apache2

S="${WORKDIR}/${MY_PN}-core-${PV}"

src_prepare() {

#	epatch "${FILESDIR}/fix-prestripped-binaries-1.7.0.patch"
	default
}

src_configure() {
	local myconf

	myconf="
	--enable-cgi-log
	--enable-classicui-standalone
	--with-ext-cmd-file-dir=/run/icinga2/cmd
	--with-cgiurl=/icinga/cgi-bin
	--with-htmurl=/icinga
	--with-log-dir=/var/log/icinga2/compat
	--with-cgi-log-dir=/var/log/icinga2/compat
	--libdir=/usr/$(get_libdir)
	--bindir=/usr/sbin
	--sbindir=/usr/$(get_libdir)/icinga/cgi-bin
	--datarootdir=/usr/share/icinga/htdocs
	--localstatedir=/var/lib/icinga
	--with-state-dir=/var/cache/icinga2
	--sysconfdir=/etc/icinga
	--with-lockfile=/var/run/icinga/icinga.lock
	--with-temp-dir=/tmp/icinga
	--with-temp-file=/tmp/icinga/icinga.tmp"

	if use !apache2 && use !lighttpd ; then
		myconf+=" --with-command-group=icinga"
	else
		if use apache2 ; then
			myconf+=" --with-httpd-conf=/etc/apache2/conf.d"
			myconf+=" --with-command-group=apache"
		elif use lighttpd ; then
			myconf+=" --with-command-group=lighttpd"
		fi
	fi

	econf ${myconf}
}

src_compile() {
	tc-export CC

	emake classicui-standalone || die "make failed"
}

src_install() {
	dodoc Changelog README UPGRADING || die

	emake DESTDIR="${D}" install{-classicui-standalone,-classicui-standalone-conf} || die

	# Apache Module
	if use apache2 ; then
		insinto "${APACHE_MODULES_CONFDIR}"
		newins "${FILESDIR}"/icinga-apache.conf 99_icinga.conf || die
	elif use lighttpd ; then
		insinto /etc/lighttpd
		newins "${FILESDIR}"/icinga-lighty.conf lighttpd_icinga.conf || die
	else
		ewarn "${CATEGORY}/${PF} only supports Apache-2.x or Lighttpd webserver"
		ewarn "out-of-the-box. Since you are not using one of them, you"
		ewarn "have to configure your webserver accordingly yourself."
	fi
	fowners -R root:root /usr/$(get_libdir)/icinga || die
	cd "${D}" || die
	find usr/$(get_libdir)/icinga -type d -exec fperms 755 {} +
	find usr/$(get_libdir)/icinga/cgi-bin -type f -exec fperms 755 {} +

	keepdir /etc/icinga

	insinto /etc/icinga
	newins "${FILESDIR}"/resource.cfg.sample resource.cfg || die
	fowners icinga:icinga /etc/icinga/resource.cfg || die

	if use apache2 ; then
		webserver=apache
	elif use lighttpd ; then
		webserver=lighttpd
	else
		webserver=icinga
	fi

#	fperms 6755 /var/lib/icinga/rw || die "Failed Chmod of ${D}/var/lib/icinga/rw"
#	fperms 0750 /etc/icinga || die "Failed chmod of ${D}/etc/icinga"

}

pkg_postinst() {
	elog
	elog "IMPORTANT:	Make sure that icinga2-features "
	elog "compat, command and  statusdata are enabled."
	elog
	elog "	icinga2 feature enable statusdata compatlog command"
	elog
	elog
	elog "Make also sure that /var/log/icinga2 got right permissions."
	elog "ClassiUI need write permissions in the log-directory, too"
	elog
	elog "	chmod 775 /var/log/icinga2/compat"
	elog
	elog
	if use apache2 || use lighttpd ; then
		elog "IMPORTANT:	Do not forget to add the user your webserver"
		elog "is running as to the icinga group!"
		elog "There are several possible solutions to accomplish this,"
		elog "choose the one you are most comfortable with:"
		elog
		if use apache2 ; then
			elog "	usermod -aG icingacmd apache"
			elog
			elog "Also edit /etc/conf.d/apache2 and add a line like"
			elog "APACHE2_OPTS=\"\$APACHE2_OPTS -D ICINGA\""
			elog
			elog "Icinga web service needs user authentication. If you"
			elog "use the base configuration, you need a password file"
			elog "with a password for user \"icingaadmin\""
			elog "You can create this file by executing:"
			elog "htpasswd -c /etc/icinga/htpasswd.users icingaadmin"
			elog
			elog "You may want to also add apache to the icinga group"
			elog "to allow it access to the AuthUserFile"
			elog
			elog "	usermod -aG icinga apache"
			elog "or"
			elog "	chown icinga:apache /etc/icinga"
		elif use lighttpd ; then
			elog "	usermod -aG icinga lighttpd "
			elog "or"
			elog "	chown icinga:lighttpd /etc/icinga"
			elog "Also edit /etc/lighttpd/lighttpd.conf and add 'include \"lighttpd_icinga.conf\"'"
		fi
		elog
	else
		elog "IMPORTANT:	Do not forget to add the user your webserver"
		elog "is running as to the icinga group!"
	fi
}
