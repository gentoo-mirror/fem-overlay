# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/csync2/csync2-1.34-r2.ebuild,v 1.5 2014/08/10 20:20:29 slyfox Exp $

EAPI=5

inherit autotools eutils git-2

DESCRIPTION="Cluster synchronization tool"
HOMEPAGE="http://oss.linbit.com/csync2/"

EGIT_REPO_URI="http://git.linbit.com/csync2.git"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

IUSE="ssl xinetd +sqlite3 mysql postgres"

REQUIRED_USE="|| ( sqlite3 mysql postgres )"

RDEPEND=">=net-libs/librsync-0.9.5
	ssl? ( >=net-libs/gnutls-2.7.3 )
	xinetd? ( sys-apps/xinetd )
	sqlite3? ( dev-db/sqlite:3 )
	postgres? ( virtual/postgresql )
	mysql? ( virtual/mysql )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

SLOT="0"

src_prepare()
{
	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		--sysconfdir=/etc/csync2 \
		$(use_enable ssl gnutls) \
		$(use_enable sqlite3) \
		$(use_enable mysql) \
		$(use_enable postgres)
}

src_install() {
	emake DESTDIR="${D}" install-exec || die

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/${PN}.xinetd ${PN} || die
	fi

	keepdir /var/lib/csync2

	newinitd "${FILESDIR}"/${PN}.initd ${PN} || die
	newconfd "${FILESDIR}"/${PN}.confd ${PN} || die

	insinto /etc/csync2
	doins csync2.cfg

	dodoc AUTHORS README csync2_locheck.sh csync2-postgres.sql || die
}

pkg_postinst() {
	if use xinetd; then
		echo
		einfo "After you setup your conf file, edit the xinetd"
		einfo "entry in /etc/xinetd.d/${PN} to enable, then"
		einfo "start xinetd: /etc/init.d/xinetd start"
	fi
	echo
	einfo "To add ${PN} to your services file"
	if use ssl; then
		einfo "and to generate the SSL certificates,"
	fi
	einfo "just run this command after you install:"
	echo
	einfo "emerge  --config =${PF}"
	echo
	einfo "Now you can find csync2.cfg under /etc/${PN}"
	einfo "Please move you old config to the right location"
	echo
	einfo "To start csync2 as a standalone daemon, simply run:"
	einfo "/etc/init.d/csync2 start"
	echo
}

pkg_config() {
	einfo "Updating ${ROOT}/etc/services"
	{ grep -v ^${PN} "${ROOT}"/etc/services;
	echo "csync2  30865/tcp"
	} > "${ROOT}"/etc/services.new
	mv -f "${ROOT}"/etc/services.new "${ROOT}"/etc/services

	if use ssl; then
		if [ ! -f "${ROOT}"/etc/${PN}/csync2_ssl_key.pem ]; then
			einfo "Creating default certificate in ${ROOT}/etc/${PN}"

			openssl genrsa -out "${ROOT}"/etc/${PN}/csync2_ssl_key.pem 1024 &> /dev/null

			yes '' | \
			openssl req -new \
				-key "${ROOT}"/etc/${PN}/csync2_ssl_key.pem \
				-out "${ROOT}"/etc/${PN}/csync2_ssl_cert.csr \
				&> "${ROOT}"/dev/null

			openssl x509 -req -days 600 \
				-in "${ROOT}"/etc/${PN}/csync2_ssl_cert.csr \
				-signkey "${ROOT}"/etc/${PN}/csync2_ssl_key.pem \
				-out "${ROOT}"/etc/${PN}/csync2_ssl_cert.pem \
				&> "${ROOT}"/dev/null

			rm "${ROOT}"/etc/${PN}/csync2_ssl_cert.csr
			chmod 400 "${ROOT}"/etc/${PN}/csync2_ssl_key.pem "${ROOT}"/etc/${PN}/csync2_ssl_cert.pem
		fi
	fi
}
