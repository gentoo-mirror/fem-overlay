# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.4.2.1-r3.ebuild,v 1.1 2009/12/08 05:24:42 jer Exp $

EAPI=2

inherit fixheadtails flag-o-matic perl-module python autotools

DESCRIPTION="Software for generating and retrieving SNMP data"
HOMEPAGE="http://net-snmp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="bzip2 diskio doc elf extensible ipv6 kernel_linux lm_sensors mfd-rewrites minimal perl python rpm selinux sendmail smux ssl tcpd X zlib"

COMMON="ssl? ( >=dev-libs/openssl-0.9.6d )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	rpm? (
		app-arch/rpm
		dev-libs/popt
		app-arch/bzip2
		>=sys-libs/zlib-1.1.4
	)
	bzip2? ( app-arch/bzip2 )
	zlib? ( >=sys-libs/zlib-1.1.4 )
	elf? ( dev-libs/elfutils )
	lm_sensors? (
		kernel_linux? ( sys-apps/lm_sensors )
	)
	python? ( dev-python/setuptools )"

RDEPEND="${COMMON}
	perl? (
		X? ( dev-perl/perl-tk )
		!minimal? ( dev-perl/TermReadKey )
	)
	selinux? ( sec-policy/selinux-snmpd )"

# Dependency on autoconf due to bug #225893
DEPEND="${COMMON}
	>=sys-devel/autoconf-2.61-r2
	>=sys-apps/sed-4
	doc? ( app-doc/doxygen )"

src_prepare() {
	# Fix CVE-2008-6123
	epatch "${FILESDIR}"/CVE-2008-6123.patch

	# lm_sensors-3 support
	if use lm_sensors ; then
		epatch "${FILESDIR}"/${PN}-5.4.1-sensors3.patch \
			"${FILESDIR}"/${PN}-5.4.1-sensors3-version_detect.patch
	fi

	# fix access violation in make check
	sed -i -e 's/\(snmpd.*\)-Lf/\1-l/' testing/eval_tools.sh || \
		die "sed eval_tools.sh failed"
	# fix path in fixproc
	sed -i -e 's|\(database_file =.*\)/local\(.*\)$|\1\2|' local/fixproc || \
		die "sed fixproc failed"

	if use python ; then
		python_get_version
		PYTHON_MODNAME="netsnmp"
		PYTHON_DIR="/usr/$(get_libdir)/python${PYVER}/site-packages"
		sed -i -e "s:\(install --basedir=\$\$dir\):\1 --root='${D}':" Makefile.in || \
			die "sed python failed"
	fi

	# snmpconf generates config files with proper selinux context
	use selinux && epatch "${FILESDIR}"/${PN}-5.1.2-snmpconf-selinux.patch

	# remove CFLAGS from net-snmp-config script (bug #257622):
	sed -i -e 's|@CFLAGS@ ||g' net-snmp-config.in

	# fix missing header file
	epatch "${FILESDIR}/${PN}-fix-agent-headers.patch"

	# Fix version number:
	sed -i -e "s:NetSnmpVersionInfo = \".*\":NetSnmpVersionInfo = \"${PV}\":" snmplib/snmp_version.c

	eautoreconf

	ht_fix_all
}

src_configure() {
	strip-flags

	local mibs="host ucd-snmp/dlmod"
	use diskio && mibs="${mibs} ucd-snmp/diskio"
	use extensible && mibs="${mibs} ucd-snmp/extensible"
	use lm_sensors && mibs="${mibs} ucd-snmp/lmsensorsMib"
	use sendmail && mibs="${mibs} mibII/mta_sendmail"
	use smux && mibs="${mibs} smux"

	local myconf="$(use_enable ipv6) \
			$(use_enable mfd-rewrites) \
			$(use_enable perl embedded-perl) \
			$(use_enable !ssl internal-md5) \
			$(use_with elf) \
			$(use_with perl perl-modules) \
			$(use_with python python-modules) \
			$(use_with ssl openssl) \
			$(use_with tcpd libwrap)"
	if use rpm ; then
		myconf="${myconf} \
			--with-rpm \
			--with-bzip2 \
			--with-zlib"
	else
		myconf="${myconf} \
			$(use_with bzip2) \
			$(use_with zlib)"
	fi

	econf \
		--with-install-prefix="${D}" \
		--with-sys-location="Unknown" \
		--with-sys-contact="root@Unknown" \
		--with-default-snmp-version="3" \
		--with-mib-modules="${mibs}" \
		--with-logfile="/var/log/net-snmpd.log" \
		--with-persistent-directory="/var/lib/net-snmp" \
		--enable-ucd-snmp-compatibility \
		--enable-shared \
		--enable-as-needed \
		${myconf}
}

src_compile() {
	emake -j1 || die "emake failed"

	if use doc ; then
		einfo "Building HTML Documentation"
		make docsdox || die "failed to build docs"
	fi
}

src_test() {
	cd testing
	if ! make test ; then
		echo
		einfo "Don't be alarmed if a few tests FAIL."
		einfo "This could happen for several reasons:"
		einfo "    - You don't already have a working configuration."
		einfo "    - Your ethernet interface isn't properly configured."
		echo
	fi
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	if use perl ; then
		fixlocalpod
		use X || rm -f "${D}"/usr/bin/tkmib
	else
		rm -f "${D}"/usr/bin/mib2c "${D}"/usr/bin/snmpcheck "${D}"/usr/bin/tkmib
	fi

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO || die
	newdoc EXAMPLE.conf.def EXAMPLE.conf || die

	use doc && { dohtml docs/html/* || die ; }

	keepdir /etc/snmp /var/lib/net-snmp

	newinitd "${FILESDIR}"/snmpd.init snmpd || die
	newconfd "${FILESDIR}"/snmpd.conf snmpd || die

	newinitd "${FILESDIR}"/snmptrapd.init snmptrapd || die
	newconfd "${FILESDIR}"/snmptrapd.conf snmptrapd || die

	# Remove everything not required for an agent.
	# Keep only the snmpd, snmptrapd, MIBs, headers and libraries.
	if use minimal; then
		elog "USE='minimal' is set. Removing excess/non-minimal components."
		rm -rf
		"${D}"/usr/bin/{encode_keychange,snmp{get,getnext,set,usm,walk,bulkwalk,table,trap,bulkget,translate,status,delta,test,df,vacm,netstat,inform,snmpcheck}}
		rm -rf "${D}"/usr/share/snmp/snmpconf-data "${D}"/usr/share/snmp/*.conf
		rm -rf "${D}"/usr/bin/{fixproc,traptoemail} "${D}"/usr/bin/snmpc{heck,onf}
		find "${D}" -name '*.pl' -exec rm -f '{}' \;
		use ipv6 || rm -rf "${D}"/usr/share/snmp/mibs/IPV6*
	fi

	# bug 113788, install example config
	insinto /etc/snmp
	newins "${S}"/EXAMPLE.conf snmpd.conf.example || die
}

pkg_postrm() {
	use python && python_mod_cleanup
}

pkg_postinst() {
	elog "An example configuration file has been installed in"
	elog "/etc/snmp/snmpd.conf.example."
}
