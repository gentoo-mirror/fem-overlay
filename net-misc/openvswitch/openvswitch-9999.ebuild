EAPI="4"

PYTHON_DEPEND="monitor? 2"

SLOT="0"
KEYWORDS="~amd64"
IUSE="debug monitor tcpdump +pyside +ssl"
LICENSE="Apache-2.0"

DESCRIPTION=""
HOMEPAGE="http://openvswitch.org/"

if [[ ${PV} == 9999* ]] ; then
        SRC_URI=""
        EGIT_REPO_URI="git://openvswitch.org/openvswitch"
        inherit linux-info linux-mod python autotools git-2
else
        inherit linux-info linux-mod python autotools
        SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"
fi

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
	linux-mod_pkg_setup
	linux_chkconfig_module BRIDGE || die "CONFIG_BRIDGE must be built as a _module_ !"
}

src_configure() {
	set_arch_to_kernel
	use pyside || export ovs_cv_pyuic4="no"
	econf \
		--with-linux="${KERNEL_DIR}" \
		--with-rundir=/var/run/openvswitch \
		--with-logdir=/var/log/openvswitch \
		--with-pkidir=/etc/openvswitch/pki \
		$(use_enable ssl) \
		$(use_enable !debug ndebug)
}

src_compile() {
	default
}

src_install() {
	default

	MODULE_NAMES="openvswitch_mod(misc:${S}:datapath/linux/) brcompat_mod(misc:${S}:datapath/linux/)"
	linux-mod_src_install

	keepdir /var/log/openvswitch
	keepdir /etc/openvswitch/pki
	rmdir "${D}/usr/share/openvswitch/ovsdbmonitor"

	newconfd "${FILESDIR}"/ovsdb-server_conf ovsdb-server || die "install failed"
	newconfd "${FILESDIR}"/ovs-vswitchd_conf ovs-vswitchd || die "install failed"
	doinitd "${FILESDIR}"/ovsdb-server || die "install failed"
	doinitd "${FILESDIR}"/ovs-vswitchd || die "install failed"
}

pkg_postinst() {
	linux-mod_pkg_postinst

	elog "Please add needed modules to:"
	if has_version sys-apps/openrc; then
		elog "/etc/conf.d/modules"
	else
		elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
	fi
}
