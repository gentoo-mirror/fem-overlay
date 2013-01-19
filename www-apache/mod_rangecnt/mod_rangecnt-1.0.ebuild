# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_loopback/mod_loopback-2.01-r1.ebuild,v 1.1 2007/07/29 14:18:03 phreak Exp $

inherit apache-module

KEYWORDS="ppc ppc64 x86 amd64"

EAPI="3"

DESCRIPTION="fixes apache Range header vulnerability"
HOMEPAGE=""
SRC_URI="http://people.apache.org/~dirkx/mod_rangecnt.c -> mod_rangecnt_${PV}.c"
LICENSE="as-is"
SLOT="0"
IUSE=""

APACHE2_MOD_CONF="28_mod_rangecnt"
APACHE2_MOD_DEFINE="RANGECNT"

#DOCFILES="CHANGES.TXT LICENSE.TXT"

need_apache2

S="${WORKDIR}"

src_unpack() { 
	cp "${DISTDIR}/mod_rangecnt_${PV}.c" "${WORKDIR}/mod_rangecnt.c"
	cp "${FILESDIR}/Makefile" "${WORKDIR}/"
}
