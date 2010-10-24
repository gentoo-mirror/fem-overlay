# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python

DESCRIPTION="everything you need to set up your Blackmagic DeckLink, Intensity or Multibridge"
HOMEPAGE="http://www.blackmagic-design.com/"
SRC_URI="http://www.blackmagic-design.com/downloads/software/DeckLink_Linux_${PV}.tar.gz"

LICENSE="Blackmagic Design"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

X86_BM_PACKAGE="DeckLink-7.9rc7-i386"
AMD64_BM_PACKAGE="DeckLink-7.9rc7-x86_64"

S="${WORKDIR}"

src_unpack() {
	if use amd64 ; then
		tar -xzf ${DISTDIR}/DeckLink_Linux_${PV}.tar.gz ${AMD64_BM_PACKAGE}.tar.gz
		tar -xzf ${WORKDIR}/${AMD64_BM_PACKAGE}.tar.gz ${AMD64_BM_PACKAGE}/usr/lib64
		LIBS="${WORKDIR}/${AMD64_BM_PACKAGE}/usr/lib64"
	else
		tar -xzf ${DISTDIR}/DeckLink_Linux_${PV}.tar.gz ${X86_BM_PACKAGE}.tar.gz
		tar -xzf ${WORKDIR}/${X86_BM_PACKAGE}.tar.gz ${X86_BM_PACKAGE}/usr/lib
		LIBS="${WORKDIR}/${X86_BM_PACKAGE}/usr/lib"
	fi
}

src_install() {
	if use amd64 ; then
		insinto /usr/lib64
		doins ${LIBS}/libDeckLinkAPI.so
		doins ${LIBS}/libDeckLinkPreviewAPI.so
	else
		insinto /usr/lib
		doins ${LIBS}/libDeckLinkAPI.so
		doins ${LIBS}/libDeckLinkPreviewAPI.so
	fi
}
