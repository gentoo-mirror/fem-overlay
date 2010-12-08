EAPI=1

inherit eutils autotools

DESCRIPTION="Nagios $PV plugins - Pack of plugins to make Nagios work properly"
HOMEPAGE="http://www.nagios.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-perl/Nagios-Plugin
	virtual/perl-version"

RESTRICT="test"

RDEPEND="${DEPEND}"

PLUGIN_LIST="check_mdstat \
			 check_hddtemp.sh \
			 check_raid \
			 check_ram \
			 check_smart_sectors \
			 ssl-cert-check \
			 check_tcptraffic"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_unpack() {
	for PLUGIN in ${PLUGIN_LIST}; do
		cp "${FILESDIR}"/${PLUGIN} "${WORKDIR}"
	done
}

src_install() {
	dodir /usr/$(get_libdir)/nagios/plugins
	exeinto /usr/$(get_libdir)/nagios/plugins
	for PLUGIN in ${PLUGIN_LIST}; do
		doexe ${PLUGIN}
	done

	chown -R nagios:nagios "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chown of ${D}usr/$(get_libdir)/nagios/plugins"

	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chmod of ${D}usr/$(get_libdir)/nagios/plugins"
}
