# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python linux-mod

DESCRIPTION="everything you need to set up your Blackmagic DeckLink, Intensity or Multibridge"
HOMEPAGE="http://www.blackmagic-design.com/"
MY_PV=${PV/_rc*}
MY_RC=${PV/_}
SRC_URI="http://www.blackmagic-design.com/downloads/software/DeckLink_Linux_${MY_PV}.tar.gz"

LICENSE="Blackmagic Design"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

#X86_BM_PACKAGE="DeckLink-7.9rc7-i386"
#AMD64_BM_PACKAGE="DeckLink-7.9rc7-x86_64"
X86_BM_PACKAGE="DeckLink-${MY_RC}-i386"
AMD64_BM_PACKAGE="DeckLink-${MY_RC}-x86_64"

S="${WORKDIR}"

src_unpack() {
	if use amd64 ; then
		tar -xzf ${DISTDIR}/DeckLink_Linux_${MY_PV}.tar.gz ${AMD64_BM_PACKAGE}.tar.gz
		tar -xzf ${WORKDIR}/${AMD64_BM_PACKAGE}.tar.gz ${AMD64_BM_PACKAGE}/usr/src/DeckLink-${MY_RC}
		tar -xzf ${WORKDIR}/${AMD64_BM_PACKAGE}.tar.gz ${AMD64_BM_PACKAGE}/etc
		KSRCDIR="${WORKDIR}/${AMD64_BM_PACKAGE}/usr/src/DeckLink-${MY_RC}/"
		UDEVRULES="${WORKDIR}/${AMD64_BM_PACKAGE}"
	else
		tar -xzf ${DISTDIR}/DeckLink_Linux_${MY_PV}.tar.gz ${X86_BM_PACKAGE}.tar.gz
		tar -xzf ${WORKDIR}/${X86_BM_PACKAGE}.tar.gz ${X86_BM_PACKAGE}/usr/src/DeckLink-${MY_RC}
		tar -xzf ${WORKDIR}/${X86_BM_PACKAGE}.tar.gz ${X86_BM_PACKAGE}/etc
		KSRCDIR="${WORKDIR}/${X86_BM_PACKAGE}/usr/src/DeckLink-${MY_RC}/"
		UDEVRULES="${WORKDIR}/${X86_BM_PACKAGE}"
	fi
}

src_compile() {
	libdir="extra/"
	BUILD_PARAMS="KERNELDIR=/lib/modules/${KV_FULL}/build"
	BUILD_TARGETS="all"
	MODULE_NAMES="blackmagic(extra:${KSRCDIR}:${KSRCDIR})"
	ebegin "Building blackmagic"
	if use kernel_linux; then
		linux-mod_src_compile
	fi
	eend $?
}

src_install() {
	if use kernel_linux; then
		linux-mod_src_install
	fi
	insinto /etc/udev/rules.d/
	doins ${UDEVRULES}/etc/udev/rules.d/20-blackmagic.rules
}
