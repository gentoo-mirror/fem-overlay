# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit db-use eutils flag-o-matic pam

DESCRIPTION="Open Source Jabber Server"
HOMEPAGE="http://jabberd2.xiaoka.com/"
SRC_URI="http://ftp.xiaoka.com/${PN}/releases/jabberd-${PV}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="berkdb debug memdebug mysql ldap pam postgres sqlite3 ssl zlib"

DEPEND="dev-libs/expat
	net-libs/udns
	net-dns/libidn
	>=virtual/gsasl-0.2.28
	berkdb? ( >=sys-libs/db-4.2 )
	mysql? ( virtual/mysql )
	ldap? ( net-nds/openldap )
	pam? ( virtual/pam )
	postgres? ( dev-db/postgresql-base )
	ssl? ( dev-libs/openssl )
	sqlite3? ( dev-db/sqlite:3 )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	dev-libs/libxml2
	>=net-im/jabber-base-0.01
	!net-im/jabberd"

S="${WORKDIR}/jabberd-${PV}"

src_configure() {
	# https://bugs.gentoo.org/show_bug.cgi?id=207655#c3
	replace-flags -O[3s] -O2

	use berkdb && myconf="${myconf} --with-extra-include-path=$(db_includedir)"

	if use debug; then
		myconf="${myconf} --enable-debug"
		# --enable-pool-debug is currently broken
		use memdebug && myconf="${myconf} --enable-nad-debug"
	else
		if use memdebug; then
			ewarn
			ewarn '"memdebug" requires "debug" enabled.'
			ewarn
		fi
	fi

	econf \
		--sysconfdir=/etc/jabber \
		--enable-fs --enable-pipe --enable-anon \
		${myconf} \
		$(use_enable berkdb db) \
		$(use_enable ldap) \
		$(use_enable mysql) \
		$(use_enable pam) \
		$(use_enable postgres pgsql) \
		$(use_enable sqlite3 sqlite) \
		$(use_enable ssl) \
		$(use_with zlib)
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	fowners jabber:jabber /usr/bin/{jabberd,router,sm,c2s,s2s}
	fperms 750 /usr/bin/{jabberd,router,sm,c2s,s2s}

	newinitd "${FILESDIR}/${PN}.init" jabberd || die "newinitd failed"
	newpamd "${FILESDIR}/${PN}.pamd" jabberd || die "newpamd failed"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/jabberd2-logrotate.conf" "jabberd" || die "newins logrotate failed"

	dodoc AUTHORS README UPGRADE
	docinto tools
	dodoc tools/db-setup{.mysql,.pgsql,.sqlite}
	dodoc tools/pipe-auth.pl

	cd "${D}/etc/jabber/"
	sed -i \
		-e 's,/var/lib/jabberd/pid/,/var/run/jabber/,g' \
		-e 's,/var/lib/jabberd/log/,/var/log/jabber/,g' \
		-e 's,/var/lib/jabberd/db,/var/spool/jabber/,g' \
		*.xml *.xml.dist || die "sed failed"
	sed -i \
		-e 's,<module>mysql</module>,<module>db</module>,' \
		c2s.xml* || die "sed failed"
	sed -i \
		-e 's,<driver>mysql</driver>,<driver>db</driver>,' \
		sm.xml* || die "sed failed"
	rm jabberd.cfg jabberd-{c2s,router,s2s,sm}.conf || die "rm failed"
	rm -r "${D}/usr/etc" || die "rm2 failed"
	find "${D}" -type f -name '*.la' -exec rm -rf '{}' '+' || die "removing .la files died"
}

pkg_postinst() {
	if use pam; then
		echo
		ewarn 'Jabberd-2 PAM authentication requires your unix usernames to'
		ewarn 'be in the form of "contactname@jabberdomain". This behavior'
		ewarn 'is likely to change in future versions of jabberd-2. It may'
		ewarn 'be advisable to avoid PAM authentication for the time being.'
		echo
		ebeep
	fi
}
