# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit apache-module

KEYWORDS="ppc ppc64 x86 amd64"

DESCRIPTION="fixes apache Range header vulnerability"
HOMEPAGE="https://people.apache.org/~dirkx/mod_rangecnt.c"
SRC_URI="https://people.apache.org/~dirkx/mod_rangecnt.c -> mod_rangecnt_${PV}.c"
LICENSE="Apache-2.0"
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
