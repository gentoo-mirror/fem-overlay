EAPI="2"

inherit linux-info linux-mod

SLOT="0"
KEYWORDS="~amd64"
IUSE="ovsdmonitor tcpdump"
LICENSE="Apache-2.0"

DESCRIPTION=""
HOMEPAGE="http://openvswitch.org/"
SRC_URI="http://openvswitch.org/releases/${P}.tar.gz"

CONFIG_CHECK="~NET_CLS_ACT ~NET_CLS_U32 ~NET_SCH_INGRESS ~NET_ACT_POLICE ~IPV6 ~TUN"

BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"
MODULE_NAMES="openvswitch_mod(misc:${S}:datapath/linux/)"

DEPEND="virtual/linux-sources"
RDEPEND="dev-libs/openssl
	ovsdmonitor? (
		>=dev-lang/python-2.4
		dev-python/twisted-conch
		dev-python/simplejson
		|| ( dev-python/pyside dev-python/PyQt4 )
		net-zope/zope-interface
	)
	tcpdump? ( net-analyzer/tcpdump )
	"
src_configure() {
	set_arch_to_kernel
	econf --with-linux="${KERNEL_DIR}"
}

pkg_setup() {
	linux-mod_pkg_setup
	linux_chkconfig_module BRIDGE || die "CONFIG_BRIDGE must be built as a _module_ !"
	BUILD_PARAMS="KERN_DIR=${KV_DIR} KERNOUT=${KV_OUT_DIR}"
}

src_install() {
	linux-mod_src_install
	emake DESTDIR="${D}" install || die 'emake install failed'
	newconfd "${FILESDIR}"/ovsdb-server_conf ovsdb-server || die "install failed"
	newconfd "${FILESDIR}"/ovs-vswitchd_conf ovs-vswitchd || die "install failed"
	doinitd "${FILESDIR}"/ovsdb-server || die "install failed"
	doinitd "${FILESDIR}"/ovs-vswitchd || die "install failed"
}

pkg_postinst() {
	linux-mod_pkg_postinst
	elog "Please add \"MODULE\" to:"
	if has_version sys-apps/openrc; then
		elog "/etc/conf.d/modules"
	else
		elog "/etc/modules.autoload.d/kernel-${KV_MAJOR}.${KV_MINOR}"
	fi
}
