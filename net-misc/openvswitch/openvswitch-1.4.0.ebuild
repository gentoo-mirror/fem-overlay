# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

PYTHON_DEPEND="monitor? 2"

inherit linux-mod linux-info python autotools

DESCRIPTION="Multilayer virtual switch for VM environments"
HOMEPAGE="http://openvswitch.org/"
SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug monitor tcpdump +pyside +ssl"

CONFIG_CHECK="~NET_CLS_ACT ~NET_CLS_U32 ~NET_SCH_INGRESS ~NET_ACT_POLICE ~IPV6 ~TUN"

RDEPEND="ssl? ( dev-libs/openssl )
	monitor? (
		>=dev-lang/python-2.4
		dev-python/twisted-conch
		dev-python/simplejson
		pyside? ( dev-python/pyside )
		!pyside? ( dev-python/PyQt4 )
		net-zope/zope-interface
	)
	tcpdump? ( net-analyzer/tcpdump )
	"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	eautoreconf
}

pkg_setup() {
	if ! linux_chkconfig_present OPENVSWITCH; then
		linux-mod_pkg_setup
		linux_chkconfig_module BRIDGE || die "CONFIG_BRIDGE must be built as a _module_ !"
	fi
}

src_configure() {
	local myconf

	set_arch_to_kernel
	use pyside || export ovs_cv_pyuic4="no"

	myconf="--with-rundir=/var/run/openvswitch \
		--with-logdir=/var/log/openvswitch \
		--with-pkidir=/etc/openvswitch/pki \
		$(use_enable ssl) \
		$(use_enable !debug ndebug)"

	if ! linux_chkconfig_present OPENVSWITCH; then
		myconf="${myconf} --with-linux=${KERNEL_DIR}"
	fi
	econf ${myconf}
}

src_compile() {
	default
}

src_install() {
	default

	if ! linux_chkconfig_present OPENVSWITCH; then
		MODULE_NAMES="openvswitch_mod(misc:${S}:datapath/linux/) brcompat_mod(misc:${S}:datapath/linux/)"
		linux-mod_src_install
	fi

	keepdir /var/log/openvswitch
	keepdir /etc/openvswitch/pki
	rmdir "${D}/usr/share/openvswitch/ovsdbmonitor"

	newconfd "${FILESDIR}"/ovsdb-server_conf ovsdb-server || die "install failed"
	newconfd "${FILESDIR}"/ovs-vswitchd_conf ovs-vswitchd || die "install failed"
	doinitd "${FILESDIR}"/ovsdb-server || die "install failed"
	doinitd "${FILESDIR}"/ovs-vswitchd || die "install failed"

	# compatiblity with upstream module untested
	if ! linux_chkconfig_present OPENVSWITCH; then
		doinitd "${FILESDIR}"/ovs-brcompatd || die "install failed"
	fi
}

pkg_postinst() {
	if linux_chkconfig_present OPENVSWITCH; then
		elog "Openvswitch kernel support detected, no extra module was build."
	else
		elog "No openvswitch kernel support detected, installing build modules."
		linux-mod_pkg_postinst
	fi

	elog "Please add needed modules to:"
	if has_version sys-apps/openrc; then
		elog "/etc/conf.d/modules"
	else
		elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
	fi
}
