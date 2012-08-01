# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils

DESCRIPTION="Nagios $PV plugins - Pack of plugins to make Nagios work properly"
HOMEPAGE="http://www.nagios.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="tcptraffic corosync haproxy apache megaraid nginx portage portageagewarn temp hddtemp +suid"

DEPEND="tcptraffic? ( dev-perl/Nagios-Plugin virtual/perl-version ) \
		corosync? ( dev-perl/Nagios-Plugin ) \
		haproxy? ( dev-perl/Nagios-Plugin dev-perl/LWP-UserAgent-Determined ) \
		apache?	( sys-devel/bc ) \
		megaraid? ( sys-block/megarc ) \
		nginx? ( sys-devel/bc net-misc/wget ) \
		portage? ( app-portage/gentoolkit ) \
		temp? ( net-analyzer/netcat sys-devel/bc ) \
		hddtemp? ( app-admin/hddtemp )"

RESTRICT="test"

RDEPEND="${DEPEND}"

PLUGIN_LIST="check_mdstat \
			 check_mount \
			 check_raid \
			 check_ram \
			 check_smart_sectors \
			 ssl-cert-check"
SUID_PLUGIN_LIST="check_smart_sectors"

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
	PLUGIN_LIST="${PLUGIN_LIST} check_apache2"
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

if use hddtemp; then
	PLUGIN_LIST="${PLUGIN_LIST} check_hddtemp.sh"
fi

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_unpack() {
	for PLUGIN in ${PLUGIN_LIST}; do
		cp "${FILESDIR}"/${PLUGIN} "${WORKDIR}"
	done

	use portage && use portageagewarn && epatch "${FILESDIR}"/check_gentoo_portage-0.8.2-age-warning.patch
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

	if use suid ; then
		for PLUGIN in ${SUID_PLUGIN_LIST}; do
			chown -R root:nagios \
				"${D}"/usr/$(get_libdir)/nagios/plugins/${PLUGIN} \
				|| die "Failed chown of ${D}usr/$(get_libdir)/nagios/plugins"
			chmod 6750 \
				"${D}"/usr/$(get_libdir)/nagios/plugins/${PLUGIN} \
				|| die "Failed setting the suid bit for various plugins"
		done
	fi
}
