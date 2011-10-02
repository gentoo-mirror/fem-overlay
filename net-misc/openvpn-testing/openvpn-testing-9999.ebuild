# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils multilib toolchain-funcs autotools flag-o-matic git

DESCRIPTION="OpenVPN is a robust and highly flexible tunneling application compatible with many OSes."

EGIT_REPO_URI="git://openvpn.git.sourceforge.net/gitroot/openvpn/openvpn-testing.git"

HOMEPAGE="http://openvpn.net/"

LICENSE="GPL-2"
SLOT="testing"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-linux"
IUSE="examples iproute2 minimal pam passwordsave selinux ssl static pkcs11 userland_BSD"

DEPEND=">=dev-libs/lzo-1.07
	kernel_linux? (
		iproute2? ( sys-apps/iproute2[-minimal] ) !iproute2? ( sys-apps/net-tools )
	)
	!minimal? ( pam? ( virtual/pam ) )
	selinux? ( sec-policy/selinux-openvpn )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	pkcs11? ( >=dev-libs/pkcs11-helper-1.05 )"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
	cd "${S}"

	epatch "${FILESDIR}/${PN}-9999-pkcs11.patch"
	sed -i \
		-e "s/gcc \${CC_FLAGS}/\${CC} \${CFLAGS} -Wall/" \
		-e "s/-shared/-shared \${LDFLAGS}/" \
		plugin/*/Makefile || die "sed failed"

	# Add GIT commit ID to Product Version
	sed -i \
		-e "/^define(PRODUCT_VERSION/s/])/-git-${EGIT_VERSION}])/" \
		version.m4

	eautoreconf
}

src_configure() {
	# basic.h defines a type 'bool' that conflicts with the altivec
	# keyword bool which has to be fixed upstream, see bugs #293840
	# and #297854.
	# For now, filter out -maltivec on ppc and append -mno-altivec, as
	# -maltivec is enabled implicitly by -mcpu and similar flags.
	(use ppc || use ppc64) && filter-flags -maltivec && append-flags -mno-altivec

	local myconf=""

	if use minimal ; then
		myconf="${myconf} --disable-plugins"
		myconf="${myconf} --disable-pkcs11"
	else
		myconf="$(use_enable pkcs11)"
	fi

	econf ${myconf} \
		$(use_enable passwordsave password-save) \
		$(use_enable ssl) \
		$(use_enable ssl crypto) \
		$(use_enable iproute2) \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		|| die "configure failed"
}

src_compile() {
	if use static ; then
		sed -i -e '/^LIBS/s/LIBS = /LIBS = -static /' Makefile || die "sed failed"
	fi

	emake || die "make failed"

	if ! use minimal ; then
		cd plugin
		for i in *; do
			[[ ${i} == "README" || ${i} == "examples" || ${i} == "defer" ]] && continue
			[[ ${i} == "auth-pam" ]] && ! use pam && continue
			einfo "Building ${i} plugin"
			emake -C "${i}" CC=$(tc-getCC) || die "make failed"
		done
		cd ..
	fi
}

src_install() {
	#make DESTDIR="${D}" install || die "make install failed"
	# Insert binary and manpage as openvpn-${SLOT} instead of using makefile
	newsbin openvpn openvpn-${SLOT}
	newman openvpn.8 openvpn-${SLOT}.8

	# install documentation
	dodoc AUTHORS ChangeLog PORTS README
	# install additional IPv6-Documentation
	dodoc README.IPv6 TODO.IPv6

	# Install some helper scripts
	keepdir /etc/openvpn-${SLOT}
	exeinto /etc/openvpn-${SLOT}
	doexe "${FILESDIR}/up.sh" || die "doexe failed"
	doexe "${FILESDIR}/down.sh" || die "doexe failed"

	# Install the init script and config file
	newinitd "${FILESDIR}/${PN}.init" openvpn-${SLOT}
	newconfd "${FILESDIR}/${PN}-2.1.conf" openvpn-${SLOT}

	# install examples, controlled by the respective useflag
	if use examples ; then
		# dodoc does not supportly support directory traversal, #15193
		insinto /usr/share/doc/${PF}-${SLOT}/examples
		doins -r sample-{config-files,keys,scripts} contrib
	fi

	# Install plugins and easy-rsa
	doenvd "${FILESDIR}/65openvpn-${SLOT}" # config-protect easy-rsa
	if ! use minimal ; then
		cd easy-rsa/2.0
		make install "DESTDIR=${D}" "PREFIX=${EPREFIX}/usr/share/${PN}/easy-rsa"
		cd ../..

		exeinto "/usr/$(get_libdir)/${PN}"
		doexe plugin/*/*.so
	fi
}

pkg_postinst() {
	# Add openvpn user so openvpn servers can drop privs
	# Clients should run as root so they can change ip addresses,
	# dns information and other such things.
	enewgroup openvpn
	enewuser openvpn "" "" "" openvpn


	if [ path_exists -o "${ROOT}/etc/openvpn-${SLOT}/*/local.conf" ] ; then
		ewarn "WARNING: The openvpn init script has changed"
		ewarn ""
	fi

	elog "The openvpn-${SLOT} init script expects to find the configuration file"
	elog "openvpn.conf in /etc/openvpn-${SLOT} along with any extra files it may need."
	elog ""
	elog "To create more VPNs, simply create a new .conf file for it and"
	elog "then create a symlink to the openvpn-${SLOT} init script from a link called"
	elog "openvpn-${SLOT}.newconfname - like so"
	elog "   cd /etc/openvpn-${SLOT}"
	elog "   ${EDITOR##*/} foo.conf"
	elog "   cd /etc/init.d"
	elog "   ln -s openvpn-${SLOT} openvpn-${SLOT}.foo"
	elog ""
	elog "You can then treat openvpn-${SLOT}.foo as any other service, so you can"
	elog "stop one vpn and start another if you need to."

	if grep -Eq "^[ \t]*(up|down)[ \t].*" "${ROOT}/etc/openvpn-${SLOT}"/*.conf 2>/dev/null ; then
		ewarn ""
		ewarn "WARNING: If you use the remote keyword then you are deemed to be"
		ewarn "a client by our init script and as such we force up,down scripts."
		ewarn "These scripts call /etc/openvpn-${SLOT}/\$SVCNAME-{up,down}.sh where you"
		ewarn "can move your scripts to."
	fi

	if ! use minimal ; then
		einfo ""
		einfo "plugins have been installed into /usr/$(get_libdir)/${PN}"
	fi

	if use eurephia ; then
		einfo ""
		einfo "This build contains eurephia patch."
		einfo "For more information please visit:"
		einfo "http://www.eurephia.net/"
	fi

	einfo ""
	einfo "This build contains a community-maintained IPv6 patch."
	einfo "For more information please visit:"
	einfo "http://www.greenie.net/ipv6/openvpn.html"

	ewarn ""
	ewarn "You are using a live ebuild building from the sources of	openvpn"
	ewarn "testing repository from: http://openvpn.git.sourceforge.net"
	ewarn ""
	ewarn "For reporting bugs please contact:"
	ewarn "openvpn-devel@lists.sourceforge.net"
}
