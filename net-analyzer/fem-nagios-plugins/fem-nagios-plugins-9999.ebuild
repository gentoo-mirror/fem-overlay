# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.fem-net.de/monitoring/fem-nagios-plugins.git"
	inherit git-r3
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	SRC_URI="https://gitlab.fem-net.de/monitoring/fem-nagios-plugins/-/archive/v${PV}/fem-nagios-plugins-v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-v${PV}"
fi

DESCRIPTION="Nagios plugins written by FeM"
HOMEPAGE="http://fem.tu-ilmenau.de"

LICENSE="GPL-2"
SLOT="0"
IUSE="bandwidth cgiirc gentoo-portage hddtemp mailqueue-exim nfs nrpe_wrapper openvpn_clients raid +ram sensors +smart_sectors temp_sensor uptime xml-rpc lvm xen net_traffic"

DEPEND="
		acct-group/nagios
		acct-user/nagios
		bandwidth? ( dev-perl/Net-SNMP ) \
		raid? ( virtual/perl-Getopt-Long ) \
		sensors? ( virtual/perl-Getopt-Long ) \
		uptime? ( virtual/perl-Getopt-Long dev-perl/Net-SNMP ) \
		xml-rpc? ( dev-python/nagiosplugin:* dev-perl/RPC-XML ) \
		xen? ( app-emulation/xen-tools ) \
"
RESTRICT="test"

RDEPEND="${DEPEND}"

PLUGIN_LIST=""

src_install () {
	if use bandwidth; then
		PLUGIN_LIST="${PLUGIN_LIST} check_bandwidth"
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

	if use lvm; then
	PLUGIN_LIST="${PLUGIN_LIST} check_vg_size check_lvm_cache"
	fi

	if use xen; then
	PLUGIN_LIST="${PLUGIN_LIST} check_xen_cpu"
	fi

	if use net_traffic; then
	PLUGIN_LIST="${PLUGIN_LIST} check_net_traffic"
	fi

	dodir /usr/$(get_libdir)/nagios/plugins
	exeinto /usr/$(get_libdir)/nagios/plugins
	for PLUGIN in ${PLUGIN_LIST}; do
		doexe ${PLUGIN}
	done

	chown -R nagios:nagios "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chown of ${D}/usr/$(get_libdir)/nagios/plugins"

	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chmod of ${D}/usr/$(get_libdir)/nagios/plugins"
}
