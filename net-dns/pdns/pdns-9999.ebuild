# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils autotools multilib subversion

DESCRIPTION="The PowerDNS Daemon"
ESVN_REPO_URI="svn://svn.powerdns.com/pdns/trunk/pdns"
ESVN_PROJECT="pdns"
HOMEPAGE="http://www.powerdns.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc ldap mysql postgres sqlite sqlite3 static opendbx"

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	ldap? ( >=net-nds/openldap-2.0.27-r4 )
	sqlite? ( =dev-db/sqlite-2.8* )
	sqlite3? ( =dev-db/sqlite-3* )
	opendbx? ( dev-db/opendbx )
	>=dev-libs/boost-1.31"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	dev-util/ragel"

src_unpack() {
	# Copy the subversion files
	subversion_src_unpack

	# We need to create the ChangeLog here
	TZ=UTC svn log -v "${ESVN_REPO_URI}" >Changelog
}

src_prepare() {
	eautoreconf --install || die "autoconf failed"
}

src_configure() {
	local modules="pipe geo" myconf=""

	use mysql && modules="${modules} gmysql"
	use postgres && modules="${modules} gpgsql"
	use sqlite && modules="${modules} gsqlite"
	use sqlite3 && modules="${modules} gsqlite3"
	use opendbx && modules="${modules} opendbx"
	use ldap && modules="${modules} ldap"
	use debug && myconf="${myconf} --enable-verbose-logging"

	econf \
		--sysconfdir=/etc/powerdns \
		--libdir=/usr/$(get_libdir)/powerdns \
		--disable-recursor \
		--with-modules= \
		--with-dynmodules="${modules}" \
		--with-pgsql-includes=/usr/include \
		--with-pgsql-lib=/usr/$(get_libdir) \
		--with-mysql-lib=/usr/$(get_libdir) \
		--with-sqlite-lib=/usr/$(get_libdir) \
		--with-sqlite3-lib=/usr/$(get_libdir) \
		$(use_enable static static-binaries) \
		${myconf} \
		|| die "econf failed"
}

src_compile() {
	default

	if use doc
	then
		emake -C codedocs codedocs || die "emake codedocs failed"
	fi
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	mv "${D}"/etc/powerdns/pdns.conf{-dist,}

	# set defaults: setuid=pdns, setgid=pdns
	sed -i \
		-e 's/^# set\([ug]\)id=$/set\1id=pdns/g' \
		"${D}"/etc/powerdns/pdns.conf

	doinitd "${FILESDIR}"/pdns

	keepdir /var/empty

	dodoc ChangeLog README TODO
	use doc && dohtml -r codedocs/html/.

	# Install development headers
	insinto /usr/include/pdns
	doins pdns/*.hh
	insinto /usr/include/pdns/backends/gsql
	doins pdns/backends/gsql/*.hh
}

pkg_preinst() {
	enewgroup pdns
	enewuser pdns -1 -1 /var/empty pdns
}

pkg_postinst() {
	elog
	elog "PowerDNS provides multiple instances support. You can create more instances"
	elog "by symlinking the pdns init script to another name."
	elog
	elog "The name must be in the format pdns.<suffix> and PowerDNS will use the"
	elog "/etc/powerdns/pdns-<suffix>.conf configuration file instead of the default."
	elog
}
