# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="A wrapper library for using smartcard readers that support PCSC only (e.g. SCR24x) with any application that supports CTAPI."
HOMEPAGE="http://pcsc-ctapi.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcsc-ctapi/${PN}-0.3.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="port0 port1 ctn0 ctn1"
KEYWORDS="~amd64"
RDEPEND="sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	local cnt=0
	use port0 && cnt="$((${cnt} + 1))"
	use port1 && cnt="$((${cnt} + 1))"
	use ctn0 && cnt="$((${cnt} + 1))"
	use ctn1 && cnt="$((${cnt} + 1))"
	if [[ "${cnt}" -gt 1 ]] ; then
		eerror "You have set more than one option to select a cardreader."
		eerror ""
		eerror "Please select at most one of the following use-flags:"
		eerror "port0: Use Portnumber (lowest input is 0) to select"
		eerror "       smartcard reader"
		eerror "port1: Use Portnumber (lowest input is 1) to select"
		eerror "       smartcard reader (e.g. Moneyplex: select COMX"
		eerror "       to select the Xth reader)."
		eerror "ctn0:  Use CTN (lowest input is 0) to select smartcard reader"
		eerror "ctn1:  Use CTN (lowest input is 1) to select smartcard reader"
		eerror "       (e.g. jameica: enter X into \"Index of Reader\" to"
		eerror "       select Xth smartcard reader)."
		eerror ""
		eerror "If you did not select any useflag the last cardreader returned"
		eerror "by pcsc is used."
		die "You have set more than one option to select a cardreader."
	fi
}

src_unpack() {
	unpack ${A}
	#cd "${S}"
	cd "${PN}-0.3"
	epatch "${FILESDIR}"/${P}-Makefile.patch
	epatch "${FILESDIR}"/${P}.patch
	if use port0; then
		#einfo "Use Portnumber (lowest input is 0) to select smartcard reader."
		append-flags -D USE_PORT_BASE0
	fi;
	if use port1; then
		# einfo "Use Portnumber (lowest input is 1) to select smartcard reader."
		append-flags -D USE_PORT_BASE1
	fi
	if use ctn0; then
		# einfo "Use CTN (lowest input is 0) to select smartcard reader."
		append-flags -D USE_CTN_BASE0
	fi
	if use ctn1; then
		# einfo "Use CTN (lowest input is 1) to select smartcard reader."
		append-flags -D USE_CTN_BASE1
	fi
	#	einfo "Using last cardreader returned by pcsc."
}

src_install () {
	cd "${PN}-0.3"
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
