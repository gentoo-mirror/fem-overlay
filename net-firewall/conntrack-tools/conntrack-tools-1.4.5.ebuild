# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit git-r3 autotools eutils linux-info

DESCRIPTION="Connection tracking userspace tools"
HOMEPAGE="http://conntrack-tools.netfilter.org"
EGIT_REPO_URI="https://stash.fem.tu-ilmenau.de/scm/nat/conntrack-tools.git"
EGIT_COMMIT="${P}"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="
	>=net-libs/libmnl-1.0.3
	>=net-libs/libnetfilter_conntrack-1.0.7
	>=net-libs/libnetfilter_cthelper-1.0.0
	>=net-libs/libnetfilter_cttimeout-1.0.0
	>=net-libs/libnetfilter_queue-1.0.2
	>=net-libs/libnfnetlink-1.0.1
	sys-libs/glibc[rpc(-)]
"
DEPEND="
	${RDEPEND}
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/xmlto
	)
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex
"

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

src_prepare() {
	default

	# bug #474858
	sed -i -e 's:/var/lock:/run/lock:' doc/stats/conntrackd.conf || die

	eautoreconf
}

src_compile() {
	# dirty, upstream package should be fixed
	emake -j1

	use doc && emake -C doc/manual
}

src_install() {
	default

	newinitd "${FILESDIR}/conntrackd.initd-r3" conntrackd
	newconfd "${FILESDIR}/conntrackd.confd-r2" conntrackd

	insinto /etc/conntrackd
	doins doc/stats/conntrackd.conf

	dodoc -r doc/sync doc/stats AUTHORS TODO
	use doc && dodoc doc/manual/${PN}.html
}
