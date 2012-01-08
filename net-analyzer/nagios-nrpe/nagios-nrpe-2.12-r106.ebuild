# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils toolchain-funcs autotools

DESCRIPTION="Nagios $PV NRPE - Nagios Remote Plugin Executor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/nrpe-${PV}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

IUSE="ssl command-args tcpd ipv6"
DEPEND=">=net-analyzer/nagios-plugins-1.3.0
	ssl? ( dev-libs/openssl )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"

S="${WORKDIR}/nrpe-${PV}"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /dev/null nagios
}

src_prepare() {
	# Add support for large output,
	# http://opsview-blog.opsera.com/dotorg/2008/08/enhancing-nrpe.html
	epatch "${FILESDIR}/multiline.patch"

	# Fix Command-Arguments in configure (Bug #397603)
	epatch "${FILESDIR}/command-args-configure.in.patch"

	# Fix tcp-wrapper dependency (Bug #326367)
	epatch "${FILESDIR}/tcp-wrapper-configure.in.patch"

	# Add IPv6
	use ipv6 && epatch "${FILESDIR}/nrpe-ipv6.patch"

	eautoconf || die "eautoconf failed"
}

src_configure() {
	local myconf

	myconf="${myconf} $(use_enable ssl) \
					  $(use_enable command-args) \
					  $(use_enable tcpd tcp-wrapper)"

	# Generate the dh.h header file for better security (2005 Mar 20 eldad)
	if use ssl ; then
		openssl dhparam -C 512 | sed -n '1,/BEGIN DH PARAMETERS/p' | grep -v "BEGIN DH PARAMETERS" > "${S}"/src/dh.h
	fi

	econf ${myconf} \
		--host=${CHOST} \
		--prefix=/usr \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios \
		--with-nrpe-user=nagios \
		--with-nrpe-group=nagios || die "econf failed"
}

src_compile() {
	emake all || die "make failed"
	# Add nifty nrpe check tool
	cd contrib
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o nrpe_check_control	nrpe_check_control.c
}

src_install() {
	dodoc LEGAL Changelog README SECURITY README.SSL \
		contrib/README.nrpe_check_control

	insinto /etc/nagios
	newins "${S}"/sample-config/nrpe.cfg nrpe.cfg
	fowners root:nagios /etc/nagios/nrpe.cfg
	fperms 0640 /etc/nagios/nrpe.cfg

	exeopts -m0750 -o nagios -g nagios
	exeinto /usr/bin
	doexe src/nrpe

	exeopts -m0750 -o nagios -g nagios
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe src/check_nrpe contrib/nrpe_check_control

	newinitd "${FILESDIR}"/nrpe-nagios3 nrpe

	# Create pidfile in /var/run/nrpe, bug #233859
	keepdir /var/run/nrpe
	fowners nagios:nagios /var/run/nrpe
	sed -i -e \
		"s#pid_file=/var/run/nrpe.pid#pid_file=/var/run/nrpe/nrpe.pid#" \
		"${D}"/etc/nagios/nrpe.cfg || die "sed failed"
}

pkg_postinst() {
	einfo
	einfo "If you are using the nrpe daemon, remember to edit"
	einfo "the config file /etc/nagios/nrpe.cfg"
	einfo

	if useq command-args ; then
		ewarn "You have enabled command-args for NRPE. This enables"
		ewarn "the ability for clients to supply arguments to commands"
		ewarn "which should be run. "
		ewarn "THIS IS CONSIDERED A SECURITY RISK!"
		ewarn "Please read /usr/share/doc/${PF}/SECURITY.bz2 for more info"
	fi
}
