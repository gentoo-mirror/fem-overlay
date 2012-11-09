# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils linux-info

DESCRIPTION="Connection tracking userspace tools"
HOMEPAGE="http://conntrack-tools.netfilter.org"
SRC_URI="http://www.netfilter.org/projects/conntrack-tools/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""

RDEPEND="
	>=net-libs/libnfnetlink-1.0.0
	>=net-libs/libnetfilter_conntrack-0.0.102
	!net-firewall/conntrack"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	linux-info_pkg_setup

	if kernel_is lt 2 6 18 ; then
		die "${PN} requires at least 2.6.18 kernel version"
	fi

	#netfilter core team has changed some option names with kernel 2.6.20
	if kernel_is lt 2 6 20 ; then
		CONFIG_CHECK="~IP_NF_CONNTRACK_NETLINK"
	else
		CONFIG_CHECK="~NF_CT_NETLINK"
	fi
	CONFIG_CHECK="${CONFIG_CHECK} ~NF_CONNTRACK
		~NETFILTER_NETLINK ~NF_CONNTRACK_EVENTS"

	check_extra_config

	linux_config_exists || \
		linux_chkconfig_present "NF_CONNTRACK_IPV4" || \
		linux_chkconfig_present "NF_CONNTRACK_IPV6" || \
		ewarn "CONFIG_NF_CONNTRACK_IPV4 or CONFIG_NF_CONNTRACK_IPV6 " \
			"are not set when one at least should be."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}/conntrackd.initd-r2" conntrackd || die
	newconfd "${FILESDIR}/conntrackd.confd-r1" conntrackd || die

	insinto /etc/conntrackd
	doins doc/stats/conntrackd.conf || die

	dodoc AUTHORS TODO || die
	insinto /usr/share/doc/${PF}
	doins -r doc/* || die
}
