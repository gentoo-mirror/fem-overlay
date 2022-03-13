# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Nagios $PV plugins - Additional Icinga/Nagios plugins"
HOMEPAGE="https://github.com/fem/nagios-plugins-extended"
SRC_URI="https://github.com/fem/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcptraffic corosync haproxy apache megaraid nginx portage portageagewarn timestamp temp hddtemp +suid"

DEPEND="acct-group/nagios
	acct-user/nagios
	tcptraffic? ( dev-perl/Monitoring-Plugin virtual/perl-version ) \
	corosync? ( dev-perl/Monitoring-Plugin ) \
	haproxy? ( dev-perl/Monitoring-Plugin dev-perl/libwww-perl ) \
	apache?	( dev-perl/Monitoring-Plugin dev-perl/libwww-perl ) \
	megaraid? ( sys-block/megarc ) \
	nginx? ( sys-devel/bc net-misc/wget ) \
	portage? ( app-portage/gentoolkit ) \
	temp? ( net-analyzer/netcat sys-devel/bc ) \
	timestamp? ( dev-perl/TimeDate ) \
	hddtemp? ( app-admin/hddtemp )"
RDEPEND="${DEPEND}"

RESTRICT="test"

PLUGIN_LIST="check_mdstat \
		 check_mount \
		 check_raid \
		 check_ram \
		 check_smart_sectors \
		 check_openvpn_clients \
		 ssl-cert-check"
SUID_PLUGIN_LIST="check_smart_sectors"

src_prepare() {
	default_src_prepare

	if use tcptraffic; then
		PLUGIN_LIST="${PLUGIN_LIST} check_tcptraffic"
	fi

	if use corosync; then
		PLUGIN_LIST="${PLUGIN_LIST} check_corosync check_corosync_rings"
	fi

	if use haproxy; then
		PLUGIN_LIST="${PLUGIN_LIST} check_haproxy"
	fi

	if use apache; then
		PLUGIN_LIST="${PLUGIN_LIST} check_apache_status"
	fi

	if use megaraid; then
		PLUGIN_LIST="${PLUGIN_LIST} check_lsi_megaraid"
	fi

	if use nginx; then
		PLUGIN_LIST="${PLUGIN_LIST} check_nginx"
	fi

	if use portage; then
		PLUGIN_LIST="${PLUGIN_LIST} check_glsa check_gentoo_portage"
		SUID_PLUGIN_LIST="${SUID_PLUGIN_LIST} check_gentoo_portage"
	fi

	if use temp; then
		PLUGIN_LIST="${PLUGIN_LIST} check_temp_sensor"
	fi

	if use timestamp; then
		PLUGIN_LIST="${PLUGIN_LIST} check_timestamp_age"
	fi

	if use hddtemp; then
		PLUGIN_LIST="${PLUGIN_LIST} check_hddtemp.sh"
	fi

	use portage && use portageagewarn && eapply "${FILESDIR}"/check_gentoo_portage-0.9.1-age-warning.patch
}

src_install() {
	dodir /usr/$(get_libdir)/nagios/plugins
	exeinto /usr/$(get_libdir)/nagios/plugins
	for PLUGIN in ${PLUGIN_LIST}; do
		doexe "${S}"/plugins/${PLUGIN}
	done

	chown -R nagios:nagios "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chown of ${D}/usr/$(get_libdir)/nagios/plugins"

	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chmod of ${D}/usr/$(get_libdir)/nagios/plugins"

	if use suid ; then
		for PLUGIN in ${SUID_PLUGIN_LIST}; do
			chown -R root:nagios \
				"${D}"/usr/$(get_libdir)/nagios/plugins/${PLUGIN} \
				|| die "Failed chown of ${D}/usr/$(get_libdir)/nagios/plugins"
			chmod 6750 \
				"${D}"/usr/$(get_libdir)/nagios/plugins/${PLUGIN} \
				|| die "Failed setting the suid bit for various plugins"
		done
	fi
}
