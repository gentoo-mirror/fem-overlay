# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

[[ ${PV} == "9999" ]] && GIT_ECLASS="git-2"
inherit autotools eutils toolchain-funcs ${GIT_ECLASS}
unset GIT_ECLASS

DESCRIPTION="Icinga NRPE - advancement of Nagios Remote Plugin Executor"
HOMEPAGE="http://www.icinga.org"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://git.icinga.org/${PN}.git"
else
	SRC_URI=""
fi

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="ssl command-args tcpd"

DEPEND=">=net-analyzer/nagios-plugins-1.3.0
	ssl? ( dev-libs/openssl )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"

RDEPEND="!net-analyzer/nagios-nrpe"

S="${WORKDIR}/nrpe-${PV}"

src_prepare() {
	epatch "${FILESDIR}/command-args-configure.in.patch"
	epatch "${FILESDIR}/tcp-wrapper-configure.in.patch"
	epatch "${FILESDIR}/nrpe_ssl_fix.patch"
	eautoconf
}


pkg_setup() {
	enewgroup icinga
	enewgroup nagios
	enewuser icinga -1 -1 /var/spool/icinga "icinga,nagios"
}

src_configure() {
	local myconf

	myconf="${myconf} $(use_enable ssl) \
					  $(use_enable command-args) \
					  $(use_enable tcpd tcp-wrapper)"

	econf ${myconf} \
		--host=${CHOST} \
		--prefix=/usr \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--localstatedir=/var/lib/icinga \
		--sysconfdir=/etc/icinga \
		--with-nrpe-user=icinga \
		--with-nrpe-group=icinga \
		--with-icinga-user=icinga \
		--with-icinga-group=icinga || die "econf failed"
}

src_compile() {
	emake all || die "make failed"
	# Add nifty nrpe check tool
	cd contrib
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o nrpe_check_control	nrpe_check_control.c
}

src_install() {
	dodoc AUTHORS LEGAL Changelog README SECURITY README.SSL THANKS \
		contrib/README.nrpe_check_control

	insinto /etc/icinga
	newins "${S}"/sample-config/nrpe.cfg nrpe.cfg
	fowners root:icinga /etc/icinga/nrpe.cfg
	fperms 0640 /etc/icinga/nrpe.cfg

	exeopts -m0750 -o icinga -g icinga
	exeinto /usr/bin
	doexe src/nrpe

	exeopts -m0750 -o icinga -g icinga
	exeinto /usr/$(get_libdir)/icinga/plugins
	doexe src/check_nrpe contrib/nrpe_check_control

	newinitd "${FILESDIR}"/nrpe.initd nrpe

	# Create pidfile in /var/run/icinga, similar to bug #233859
	keepdir /var/run/icinga
	fowners icinga:icinga /var/run/icinga
	sed -i -e \
		"s#pid_file=/var/run/icinga-nrpe.pid#pid_file=/var/run/icinga/nrpe.pid#" \
		"${D}"/etc/icinga/nrpe.cfg || die "sed failed"
}

pkg_postinst() {
	einfo
	einfo "If you are using the nrpe daemon, remember to edit"
	einfo "the config file /etc/icinga/nrpe.cfg"
	einfo

	if use command-args ; then
		ewarn "You have enabled command-args for NRPE. This enables"
		ewarn "the ability for clients to supply arguments to commands"
		ewarn "which should be run. "
		ewarn "THIS IS CONSIDERED A SECURITY RISK!"
		ewarn "Please read /usr/share/doc/${PF}/SECURITY.bz2 for more info"
	fi
}
