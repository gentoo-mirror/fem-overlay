# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
HOMEPAGE="https://gitlab.fem-net.de/monitoring/fem-nagios-plugins/"

# Mappings between USE flag and plugin name in the form: flag[:plugin].
# If the plugin is not explicitly specified, it is the same as the flag name.
PLUGIN_FLAG_MAP=(
	bandwidth hddtemp raid sensors uptime xml-rpc xen:xen_cpu
)

LICENSE="BSD GPL-2 GPL-3 MIT"
SLOT="0"
IUSE="${PLUGIN_FLAG_MAP[@]%:*}"

RDEPEND="
		acct-group/nagios
		acct-user/nagios
		app-alternatives/bc
		bandwidth? ( dev-perl/Net-SNMP )
		hddtemp? ( app-admin/hddtemp )
		raid? ( virtual/perl-Getopt-Long )
		sensors? ( virtual/perl-Getopt-Long )
		uptime? ( virtual/perl-Getopt-Long dev-perl/Net-SNMP )
		xml-rpc? ( dev-python/nagiosplugin:* dev-perl/RPC-XML )
		xen? ( app-emulation/xen-tools )
"
RESTRICT="test"

# List of all plugins to be installed, without the `check_` prefix.
# This list is extended conditionally using PLUGIN_FLAG_MAP depending on the
# USE flags set
PLUGIN_LIST=(
	cgiirc gentoo_portage mailqueue_exim nfs nrpe_wrapper openvpn_clients ram ram2 smart_sectors temp_sensor vg_size lvm_cache net_traffic zfs
)

DOCS=( README.md CHANGELOG.md )

# The provided Makefile only has an install function
src_compile() {
	:
}

src_install () {
	einstalldocs

	for mapping in "${PLUGIN_FLAG_MAP[@]}"; do
		local flag="${mapping%:*}"

		if ! use "${flag}"; then
			continue
		fi

		local plugin="${mapping#*:}"
		if [[ "${plugin}" == "" ]]; then
			plugin="${flag#+}"
		fi

		PLUGIN_LIST+=( "${plugin}" )
	done

	dodir /usr/$(get_libdir)/nagios/plugins
	exeinto /usr/$(get_libdir)/nagios/plugins
	for plugin in "${PLUGIN_LIST[@]}"; do
		doexe "check_${plugin}"
	done
}
