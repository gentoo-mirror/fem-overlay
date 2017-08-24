# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5


DESCRIPTION="Nagios plugins written by FeM"
HOMEPAGE="http://fem.tu-ilmenau.de"
EGIT_REPO_URI="https://stash.fem.tu-ilmenau.de/scm/monitor/fem-nagios-plugins.git"
EGIT_BRANCH="master"
#SRC_URI=""
inherit eutils user git-r3
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="bandwidth cgiirc gentoo-portage hddtemp mailqueue-exim nfs nrpe_wrapper openvpn_clients raid +ram sensors +smart_sectors temp_sensor uptime xml-rpc"

DEPEND="bandwidth? ( dev-perl/Net-SNMP ) \
		raid? ( virtual/perl-Getopt-Long ) \
		sensors? ( virtual/perl-Getopt-Long ) \
		uptime? ( virtual/perl-Getopt-Long  dev-perl/Net-SNMP ) \
		xml-rpc? ( dev-python/nagiosplugin dev-perl/RPC-XML ) \
"
RESTRICT="test"

RDEPEND="${DEPEND}"

#S=${WORKDIR}

PLUGIN_LIST=""

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_install () {
    if use bandwidth; then
		PLUGIN_LIST="${PLUGIN_LIST} check_bindwidth"
	fi

	if use cgiirc; then
		PLUGIN_LIST="${PLUGIN_LIST} check_cgiirc"
	fi

	if use gentoo-portage; then
		PLUGIN_LIST="${PLUGIN_LIST} check_gentoo_portage"
	fi

	if use hddtemp; then
		PLUGIN_LIST="${PLUGIN_LIST} check_hddtemp.sh"
	fi

	if use mailqueue-exim; then
		PLUGIN_LIST="${PLUGIN_LIST} check_mailqueue_exim"
	fi

	if use nfs; then
		PLUGIN_LIST="${PLUGIN_LIST} check_nfs"
	fi

	if use nrpe_wrapper; then
		PLUGIN_LIST="${PLUGIN_LIST} check_nrpe_wrapper"
	fi

	if use openvpn_clients; then
		PLUGIN_LIST="${PLUGIN_LIST} check_openvpn_clients"
	fi

	if use raid; then
		PLUGIN_LIST="${PLUGIN_LIST} check_raid"
	fi

	if use ram; then
		PLUGIN_LIST="${PLUGIN_LIST} check_ram"
	fi
	
	if use sensors; then
        PLUGIN_LIST="${PLUGIN_LIST} check_sensors"
    fi

    if use smart_sectors; then
        PLUGIN_LIST="${PLUGIN_LIST} check_smart_sectors"
    fi

	if use temp_sensor; then
        PLUGIN_LIST="${PLUGIN_LIST} check_temp_sensor"
    fi

    if use uptime; then
        PLUGIN_LIST="${PLUGIN_LIST} check_uptime"
    fi

    if use xml-rpc; then
        PLUGIN_LIST="${PLUGIN_LIST} check_xml-rpc"
    fi

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
